# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                             :integer          not null, primary key
#  user_id                        :integer          not null
#  parent_id                      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  root_comment_id                :integer
#  level                          :integer          default(0)
#  story_id                       :integer          not null
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @story = create(:story, user: @user)
  end

  # test 'should create' do
  #   comment = Comment.create(user: @user, story: @story, content: Faker::Fantasy::Tolkien.poem)

  #   assert comment.valid?
  # end

  # test 'should not create without user and should return validation error' do
  #   comment = Comment.create(story: @story, content: Faker::Fantasy::Tolkien.poem)

  #   assert_not comment.valid?
  #   assert_equal ['User must exist'], comment.errors.full_messages
  # end

  # test 'should not create without story and should return validation error' do
  #   comment = Comment.create(user: @user, content: Faker::Fantasy::Tolkien.poem)

  #   assert_not comment.valid?
  #   assert_equal ['story must exist'], comment.errors.full_messages
  # end

  # test 'should not create without content and should return validation error' do
  #   comment = Comment.create(user: @user, story: @story)

  #   assert_not comment.valid?
  #   assert_equal ['Content can\'t be blank'], comment.errors.full_messages
  # end

  # test 'should create with large content' do
  #   comment = Comment.create(user: @user, story: @story, content: 'a' * 32768)

  #   assert comment.valid?
  #   assert_equal 32768, comment.content.to_plain_text.length
  # end

  # test 'user relationship works' do
  #   comment = Comment.create(user: @user, story: @story, content: Faker::Fantasy::Tolkien.poem)

  #   assert_equal @user, comment.user
  # end

  # test 'story comments relationship works' do
  #   comment = Comment.create(user: @user, story: @story, content: Faker::Fantasy::Tolkien.poem)

  #   assert_equal @story, comment.story
  #   assert_equal @story.comments, [comment]
  # end

  # test 'parent comments relationship works' do
  #   comment = create(:comment, :of_story)
  #   comment_2 = Comment.create(user: @user, story: comment, parent: comment, content: Faker::Fantasy::Tolkien.poem)

  #   assert_equal comment, comment_2.story
  #   assert_equal comment.comments, [comment_2]
  # end
end
