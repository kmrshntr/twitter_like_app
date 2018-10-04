require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  	@micropost = microposts(:orange)
  end
  
  test "layouts link" do
	get root_path
	#assert_template 'static_pages#home'
	assert_select 'a[href=?]', root_path, count:2
	assert_select 'a[href=?]', help_path
	assert_select 'a[href=?]', about_path
	assert_select 'a[href=?]', contact_path
	assert_select 'a[href=?]', signup_path
	get contact_path
	assert_select 'title', full_title("Contact")	
  end

  test "feed search work perfectly" do
  	log_in_as(@user)
  	get root_path, params: { search: @micropost.content }
  	assert_match @micropost.content, response.body
  end
end
