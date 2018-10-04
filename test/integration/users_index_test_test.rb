require 'test_helper'

class UsersIndexTestTest < ActionDispatch::IntegrationTest
  def setup
  	@admin = users(:michael)
    @non_admin = users(:archer)
    @lana = users(:lana)
  end

  test "index as admin including pagination and delete" do
  	log_in_as(@admin)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination', count: 2
  	User.paginate(page: 1).each do |user|
  		assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
  	end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non admin user' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0 
  end

  test "search feed work perfectly at user index" do
    log_in_as(@admin)
    get users_path, params: { search: @non_admin.name }
    assert_match @non_admin.name, response.body
    assert_no_match @lana.name, response.body
  end
end
