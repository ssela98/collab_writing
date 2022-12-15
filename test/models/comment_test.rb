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

  test 'should create' do
    comment = Comment.create(user: @user, story: @story, content: Faker::Fantasy::Tolkien.poem)

    assert comment.valid?
  end

  test 'should not create without user and should return validation error' do
    comment = Comment.create(story: @story, content: Faker::Fantasy::Tolkien.poem)

    assert_not comment.valid?
    assert_equal ['User must exist'], comment.errors.full_messages
  end

  test 'should not create without story and should return validation error' do
    comment = Comment.create(user: @user, content: Faker::Fantasy::Tolkien.poem)

    assert_not comment.valid?
    assert_equal ['Story must exist'], comment.errors.full_messages
  end

  test 'should not create without content and should return validation error' do
    comment = Comment.create(user: @user, story: @story)

    assert_not comment.valid?
    assert_equal ['Content can\'t be blank'], comment.errors.full_messages
  end

  test 'should create with large content' do
    comment = create(:comment, content: 'a' * 32768)

    assert comment.valid?
    assert_equal 32768, comment.content.to_plain_text.length
  end

  test 'should set level after create' do
    comment = create(:comment, story: @story)
    comment_lvl_2 = create(:comment, story: @story, parent: comment)
    comment_lvl_3 = create(:comment, story: @story, parent: comment_lvl_2)

    assert_equal 1, comment_lvl_2.level
    assert_equal 2, comment_lvl_3.level
  end

  test 'should set root_comment_id after create' do
    comment = create(:comment, story: @story)
    reply_comment = create(:comment, story: @story, parent: comment)

    assert_equal comment.id, reply_comment.root_comment_id
  end

  test 'should reset root_comment_id after 10 comments' do
    comment = create(:comment, story: @story)
    comment_2 = create(:comment, story: @story, parent: comment)
    comment_3 = create(:comment, story: @story, parent: comment_2)
    comment_4 = create(:comment, story: @story, parent: comment_3)
    comment_5 = create(:comment, story: @story, parent: comment_4)
    comment_6 = create(:comment, story: @story, parent: comment_5)
    comment_7 = create(:comment, story: @story, parent: comment_6)
    comment_8 = create(:comment, story: @story, parent: comment_7)
    comment_9 = create(:comment, story: @story, parent: comment_8)
    comment_10 = create(:comment, story: @story, parent: comment_9)
    comment_11 = create(:comment, story: @story, parent: comment_10)

    assert_equal comment.id, comment_10.root_comment_id
    assert_equal comment_11.id, comment_11.root_comment_id
  end

  test 'voting works' do
    comment = create(:comment)

    comment.upvote! @user
    assert_equal 1, comment.weighted_score

    comment.upvote! @user
    comment.upvote! @user
    assert_equal 1, comment.weighted_score # nothing changed

    comment.downvote! @user
    assert_equal -1, comment.weighted_score

    comment.downvote! @user
    comment.downvote! @user
    assert_equal -1, comment.weighted_score # nothing changed
  end

  test 'ordering works' do
    comment = create(:comment, story: @story)
    top_comment = create(:comment, story: @story)
    newest_comment = create(:comment, story: @story)

    top_comment.upvote! @user

    assert_equal newest_comment, Comment.order_by_keyword('new').first
    assert_equal top_comment, Comment.order_by_keyword('top').first
  end

  test 'finding by content works' do
    content = Faker::Fantasy::Tolkien.poem
    comment = create(:comment, content:)

    assert_equal [comment], Comment.where_content(content)
  end

  test 'user relationship works' do
    comment = create(:comment, user: @user)

    assert_equal @user, comment.user
  end

  test 'story comments relationship works' do
    comment = create(:comment, story: @story)

    assert_equal @story, comment.story
    assert_equal @story.comments, [comment]
  end

  test 'parent comments relationship works' do
    comment = create(:comment)
    comment_2 = create(:comment, story: comment.story, parent: comment)

    assert_equal comment.story, comment_2.story
    assert_equal comment.comments, [comment_2]
  end

  test 'pin relationship works' do
    comment = create(:comment)
    pin = create(:pin, comment:)

    assert_equal pin, comment.pin
  end
end
