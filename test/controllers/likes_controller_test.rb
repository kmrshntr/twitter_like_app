require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest

 test "create should redirect when not logeed in" do
 	assert_no_difference 'Like.count' do
 		post likes_path
 	end
 	assert_redirected_to login_url
 end

 test "destroy should redirect when not logged in" do
 	assert_no_difference 'Like.count' do
 		delete like_path(likes(:one))
 	end
 	assert_redirected_to login_url
 end
end
