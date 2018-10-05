require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
  	@comment = Comment.new(content: 'example', user_id: users(:michael).id, micropost_id: microposts(:orange).id)
  end

  test "should be valid" do
  	assert @comment.valid?
  end

  test "content should be presence" do
  	@comment.content = nil
  	assert_not @comment.valid?
  end

  test "content should be less than 140" do
    @comment.content = 'a' * 141
    assert_not @comment.valid?
  end

  test "user_id should be presence" do
  	@comment.user_id = nil
  	assert_not @comment.valid?
  end

  test "micropost_id should be presence" do
  	@comment.micropost_id = nil
  	assert_not @comment.valid?
  end

end
