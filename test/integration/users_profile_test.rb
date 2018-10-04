require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

def setup
	@user = users(:michael)
	@micropost = microposts(:orange)
end 

test "profile display" do
	get user_path(@user)
	assert_template 'users/show'
	assert_select 'title', full_title(@user.name)
	assert_select 'h1', text: @user.name
	assert_select 'h1>img.gravatar'
	assert_match @user.microposts.count.to_s, response.body
	assert_select 'div.pagination'
	@user.microposts.paginate(page: 1).each do |micropost|
		assert_match micropost.content, response.body
	end
end

test "search micropost work perfectly at show" do
	get user_path(@user), params: { search: @micropost.content }
	assert_match @micropost.content, response.body
end

end
