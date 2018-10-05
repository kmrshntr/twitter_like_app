require 'test_helper'

class CommentInterfaceTest < ActionDispatch::IntegrationTest
 
 def setup
 	@user = users(:michael)
 	@micropost = microposts(:ants)
 end

 test "comment_interface" do
 	log_in_as(@user)
 	get micropost_path(@micropost)
 	#無効なコメントを入力
 	assert_no_difference '@micropost.comments.count' do
 		post comments_path, params: { micropost_id: @micropost.id, comment: { content: "" } }
 	end
 	assert_select 'div#error_explanation'
 	#有効なコメントを送信
 	content = "content"
 	assert_difference '@micropost.comments.count', 1 do
 		post comments_path, params: { micropost_id: @micropost.id, comment: { content: content } }
 	end
 	assert_redirected_to micropost_path(@micropost)
 	follow_redirect!	
 	assert_match content, response.body
 	#コメントを削除する
 	assert_select 'a', text: "delete"
 	first_comment = @micropost.comments.first
 	assert_difference '@micropost.comments.count', -1 do
 		delete comment_path(first_comment), params: { micropost_id: @micropost.id }
 	end
 	assert_redirected_to micropost_path(@micropost)
 end

 test "comment with Ajax" do
 	log_in_as(@user)
 	assert_difference '@micropost.comments.count', 1 do
 		post comments_path, xhr: true, params: { micropost_id: @micropost.id, comment: { content: "hello world" } }
 	end
 end

end
