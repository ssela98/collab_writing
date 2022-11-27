# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # setup do
  #   @user = create(:user)
  #   @stranger = create(:user)
  #   @comment = create(:comment, :of_story, user: @user)
  # end

  # test 'should show comment' do
  #   get comment_url(@comment)

  #   assert_response :success
  # end

  # test 'should get edit' do
  #   sign_in @user
  #   get edit_comment_url(@comment)

  #   assert_response :success
  # end

  # test 'should not get edit if not signed in and should redirected to sign in' do
  #   get edit_comment_url(@comment)

  #   assert_redirected_to new_user_session_path
  #   assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  # end

  # test 'should not get edit if signed in as another user and should get forbidden response' do
  #   sign_in @stranger
  #   get edit_comment_url(@comment)

  #   assert_response :forbidden
  #   assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  # end

  # test 'should create on story' do
  #   sign_in @user
  #   content = Faker::Fantasy::Tolkien.poem

  #   assert_difference 'Comment.count', 1 do
  #     post "/stories/#{@story.id}/comments", params: { comment: { content: }, format: :turbo_stream }
  #   end

  #   comment = Comment.find_by(user: @user, story: @story, parent: nil)

  #   assert_response :success
  #   assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
  #   assert_equal @user, comment.user
  #   assert_equal content, comment.content.to_plain_text
  #   assert_equal @story, comment.story
  #   assert_equal [comment], @story.comments
  # end

  # test 'should not create on story if not signed in' do
  #   content = Faker::Fantasy::Tolkien.poem

  #   assert_difference 'Comment.count', 0 do
  #     post "/stories/#{@story.id}/comments", params: { comment: { content: }, format: :turbo_stream }
  #   end

  #   assert_redirected_to new_user_session_path
  #   assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  # end

  # test 'should create reply' do
  #   sign_in @user
  #   content = Faker::Fantasy::Tolkien.poem

  #   assert_difference 'Comment.count', 1 do
  #     post comment_comments_url(comment_id: @story.id), params: { comment: { content: }, format: :turbo_stream }
  #   end

  #   comment = Comment.find_by(user: @user, story: @story.story, parent: @story)

  #   assert_response :success
  #   assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
  #   assert_equal @user, comment.user
  #   assert_equal content, comment.content.to_plain_text
  #   assert_equal @story, comment.parent
  #   assert_equal @story.story, comment.story
  # end

  # test 'should not create reply if not signed in' do
  #   content = Faker::Fantasy::Tolkien.poem

  #   assert_difference 'Comment.count', 0 do
  #     post comment_comments_url(comment_id: @story.id), params: { comment: { content: }, format: :turbo_stream }
  #   end

  #   assert_redirected_to new_user_session_path
  #   assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  # end

  # test 'should update comment' do
  #   sign_in @user
  #   content = Faker::Fantasy::Tolkien.poem

  #   patch comment_url(@comment), params: { comment: { content: }, format: :turbo_stream }
  #   @comment.reload

  #   assert_response :success
  #   assert_equal I18n.t('comments.notices.successfully_updated'), flash.now[:notice]
  #   assert_equal content, @comment.content.to_plain_text
  # end

  # test 'should not update comment if not signed in' do
  #   patch comment_url(@comment), params: { comment: { content: Faker::Fantasy::Tolkien.poem }, format: :turbo_stream }

  #   assert_redirected_to new_user_session_path
  #   assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  # end

  # test 'should not update comment if signed in as another user and should get forbidden response' do
  #   sign_in @stranger
  #   patch comment_url(@comment), params: { comment: { content: Faker::Fantasy::Tolkien.poem }, format: :turbo_stream }

  #   assert_response :forbidden
  #   assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  # end

  # test 'should destroy comment' do
  #   sign_in @user
  #   story = @comment.story

  #   assert_difference 'Comment.count', -1 do
  #     delete comment_url(@comment)
  #   end

  #   assert_redirected_to story
  #   assert_equal I18n.t('comments.notices.successfully_destroyed'), flash[:notice]
  # end

  # test 'should not destroy comment if not signed in' do
  #   assert_difference 'Comment.count', 0 do
  #     delete comment_url(@comment)
  #   end

  #   assert_redirected_to new_user_session_path
  #   assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  # end

  # test 'should not destroy comment if signed in as another user and should get forbidden response' do
  #   sign_in @stranger
  #   assert_difference 'Comment.count', 0 do
  #     delete comment_url(@comment)
  #   end

  #   assert_response :forbidden
  #   assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  # end
end
