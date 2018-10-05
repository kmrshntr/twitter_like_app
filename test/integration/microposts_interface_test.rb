require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
  	#無効な送信
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, params: { micropost: { content: "" } }
  	end
  	assert_select 'div#error_explanation'
  	#有効な送信
  	content = "content"
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, params: { micropost: { content: content } }
  	end
  	assert_not flash.empty?
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match content, response.body
  	#投稿を削除する
  	assert_select 'a', text: "delete"
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do 
  		delete micropost_path(first_micropost)
  	end
  	assert_not flash.empty?
  	#違うユーザーのプロフィールにアクセス（削除リンクが無いことを確認）
  	get user_path(users(:archer))
  	assert_select 'a', text: "delete", count: 0
  end
end
