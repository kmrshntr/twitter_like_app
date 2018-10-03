require 'test_helper'

class UserLikeTest < ActionDispatch::IntegrationTest
 	def setup
 		@user = users(:michael)
 		log_in_as(@user)
	 	@micropost1 = microposts(:orange)
	 	@micropost2 = microposts(:tau_manifesto)
	 	@like = likes(:one)
	end
  
	test "should like a micropost standard way" do
		assert_difference '@micropost2.likes.count', 1 do
			post likes_path, params: { micropost_id: @micropost2.id }
		end
	end

	test 'should like a micropost with Ajax' do
		assert_difference '@micropost2.likes.count', 1 do
			post likes_path, params: { micropost_id: @micropost2.id }, xhr: true
		end
	end

	test 'should unlike a micropost standard way' do
		assert_difference '@micropost1.likes.count', -1 do
			delete like_path(@like)
		end
	end

	test 'should unlike a micropost with Ajax' do
		assert_difference '@micropost1.likes.count', -1 do
			delete like_path(@like), xhr: true
		end
	end


end
