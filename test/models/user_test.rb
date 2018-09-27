require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "example_user", email: "example@example.com")
  end

  test "should be valid user" do
  	assert @user.valid?
  end
end
