require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "example_user", email: "example@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid user" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "	"
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "  "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
     valid_addresses.each do |valid_address|
     	@user.email = valid_address
     	assert @user.valid?, "#{valid_address.inspect} should be valid"
     end
  end

  test "email validation should reject invalid addresses" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
    	@user.email = invalid_address
    	assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should not be duplicate" do
  	dupicate_user = @user.dup
  	dupicate_user.email = @user.email.upcase
  	@user.save
  	assert_not dupicate_user.valid? 
  end

  test "email should be downcase in datebase" do
  	mixed_email = "FOO@EXamPLE.COM" 
  	@user.email = mixed_email
  	@user.save
  	assert_equal mixed_email.downcase, @user.reload.email 
  end

  test "password should not be too long" do
  	@user.password =  @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "password should be present" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "authenticated? should return flase when remember digest is nil" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create(content: "example")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    #フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    #自分自身の投稿が含まれているか確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    #フォローしていないユーザーの投稿が含まれていない事を確認
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

  test "associated comments should be destroyed" do
    archer = users(:archer)
    micropost = microposts(:ants)
    content = "example"  
    micropost.comments.create(content: content, user_id: archer.id)
    assert_difference 'micropost.comments.count', -1 do
      archer.destroy
    end
  end
end
