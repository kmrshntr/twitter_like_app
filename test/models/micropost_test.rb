require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

	def setup
		@michael = users(:michael)
		@micropost = microposts(:orange)
		@archer = users(:archer)
	end

	test "should be valid" do
		assert @micropost.valid?
	end

	test "user id should be present" do
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content should be present" do
		@micropost.content = nil
		assert_not @micropost.valid?
	end

	test "content should be at most 140 characters" do
		@micropost.content = "a" * 141
		assert_not @micropost.valid?
	end

	test "order should be most resent first" do
		assert_equal microposts(:most_recent), Micropost.first
	end

	test "should like and unlike micropost" do
		assert_not @micropost.liked?(@archer)
		@micropost.like(@archer)
		assert @micropost.liked?(@archer)
		@micropost.unlike(@archer)
		assert_not @micropost.liked?(@archer)
	end
end
