require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
		@micropost = microposts(:orange)
		@comment = comments(:fight)
	end
  
	test "create should redirect when not logged in" do
		post comments_path, params: { micropost_id: @micropost.id, comment: { content: "example" } }
		assert_redirected_to login_url
	end

	test "destroy should redirect whent not logged in" do
		delete comment_path(@comment)
		assert_redirected_to login_url
	end

	test "destroy should redirect when not correct user" do
		log_in_as(users(:archer))
		delete comment_path(@comment)
		assert_redirected_to root_url
	end
end
