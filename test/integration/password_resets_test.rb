require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
 
 def setup
 	ActionMailer::Base.deliveries.clear
 	@user = users(:michael)
 end

 test "password resets" do
 	get new_password_reset_path
 	assert_template 'password_resets/new'
 	#メールアドレスが無効
 	post password_resets_path, params: { password_reset: { email: "wrong" } }
 	assert_not flash.empty?
 	assert_template "password_resets/new"
 	#メールアドレスが有効
 	post password_resets_path, params: { password_reset: { email: @user.email } }
 	assert_not flash.empty?
 	assert_not_equal @user.reset_digest, @user.reload.reset_digest
 	assert_equal 1, ActionMailer::Base.deliveries.size
 	assert_redirected_to root_url
 	#パスワード再設定フォームのテスト
 	user = assigns(:user)
 	#メールアドレスが無効
 	get edit_password_reset_path(user.reset_token, email: "wrong")
 	assert_redirected_to root_url
 	#無効なユーザー
 	user.toggle!(:activated)
 	get edit_password_reset_path(user.reset_token, email: user.email)
 	assert_redirected_to root_url
 	user.toggle!(:activated)
 	#メールアドレスが有効で、トークンが無効
 	get edit_password_reset_path("wrong", email: user.email)
 	assert_redirected_to root_url
 	#メールアドレスもトークンも有効
 	get edit_password_reset_path(user.reset_token, email: user.email)
 	assert_template "password_resets/edit"
 	assert_select "input[name=email][type=hidden][value=?]", user.email
 	#無効なパスワードとパスワード確認
 	patch password_reset_path(user.reset_token), params: { email: user.email,
 															user: { password: "foobaz",
 																	password_confirmation: "hogehoge" } }
 	assert_select "div#error_explanation"
 	#パスワードが空
 	patch password_reset_path(user.reset_token), params: { email: user.email,
 															user: { password: "",
 																	password_confirmation: "" } }
 	assert_select "div#error_explanation"
 	#有効なパスワードとパスワード確認
 	patch password_reset_path(user.reset_token), params: { email: user.email,
 															user: { password: "passcord",
 																	password_confirmation: "passcord" } }
 	assert is_logged_in?
 	assert_nil user.reload.reset_digest
 	assert_not flash.empty?
 	assert_redirected_to user
 end

end
