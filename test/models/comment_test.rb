# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_type :string           not null
#  commentable_id   :integer          not null
#  parent_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @commentable = create(:story, user: @user)
  end

  test 'should create' do
    comment = Comment.create(user: @user, commentable: @commentable, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert comment.valid?
  end

  test 'should not create without user and should return validation error' do
    comment = Comment.create(commentable: @commentable, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert_not comment.valid?
    assert_equal ['User must exist'], comment.errors.full_messages
  end

  test 'should not create without commentable and should return validation error' do
    comment = Comment.create(user: @user, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert_not comment.valid?
    assert_equal ['Commentable must exist'], comment.errors.full_messages
  end

  test 'should not create without content and should return validation error' do
    comment = Comment.create(user: @user, commentable: @commentable)

    assert_not comment.valid?
    assert_equal ['Content can\'t be blank'], comment.errors.full_messages
  end

  test 'should create with large content' do
    comment = Comment.create(user: @user, commentable: @commentable, content: 'a' * 32768)

    assert comment.valid?
    assert_equal 32768, comment.content.to_plain_text.length
  end

  test 'user relationship works' do
    comment = Comment.create(user: @user, commentable: @commentable, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert_equal @user, comment.user
  end

  test 'commentable comments relationship works' do
    comment = Comment.create(user: @user, commentable: @commentable, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert_equal @commentable, comment.commentable
    assert_equal @commentable.comments, [comment]
  end

  test 'parent comments relationship works' do
    comment = create(:comment, :of_story)
    comment_2 = Comment.create(user: @user, commentable: comment, parent: comment, content: "<p>#{ Faker::Fantasy::Tolkien.poem }</>")

    assert_equal comment, comment_2.commentable
    assert_equal comment.comments, [comment_2]
  end
end
