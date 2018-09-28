require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "should redirect signup with invalid information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, params: { user: { name: "",
  											email: "",
  											password: "foo",
  											password_confirmation: "bar" } }
  	end
  	assert_template 'users/new'
  	assert_select 'div#error_explanation'
  	assert_select 'div.field_with_errors'
  end

  test "signup with valid information" do
  	get signup_path
  	assert_difference 'User.count', 1 do
 		post users_path, params: { user: { name: "exmaple",
  											email: "exmaple@gmail.com",
  											password: "foobar",
  											password_confirmation: "foobar" } }
  	end
  	follow_redirect!
  	assert_template 'users/show'
  	assert_not flash.empty?
    assert is_logged_in?
  end

end
