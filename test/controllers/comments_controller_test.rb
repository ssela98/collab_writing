# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @stranger = create(:user)
    @story = create(:story)
    @comment = create(:comment, user: @user, story: @story)
  end

  test 'should show comment' do
    get comment_url(@comment, { story_id: @comment.story.id })

    assert_redirected_to story_path(anchor: dom_id(@comment))
  end

  test 'should get edit' do
    sign_in @user
    get edit_comment_url(@comment, format: :turbo_stream)

    assert_response :success
  end

  test 'should not get edit if not signed in and should redirected to sign in' do
    get edit_comment_url(@comment, format: :turbo_stream)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not get edit if signed in as another user' do
    sign_in @stranger
    get edit_comment_url(@comment, format: :turbo_stream)

    assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  end

  test 'should create' do
    sign_in @user
    content = Faker::Fantasy::Tolkien.poem

    assert_difference 'Comment.count', 1 do
      post comments_url(story_id: @story.id, comment: { content: }, format: :turbo_stream)
    end

    assert_response :success
    assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
  end

  test 'should not create if not signed in' do
    content = Faker::Fantasy::Tolkien.poem

    assert_difference 'Comment.count', 0 do
      post comments_url(story_id: @story.id, comment: { content: }, format: :turbo_stream)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should create reply' do
    sign_in @user
    content = Faker::Fantasy::Tolkien.poem

    assert_difference 'Comment.count', 1 do
      post comments_url(story_id: @story.id, comment_id: @comment.id, comment: { content: }, format: :turbo_stream)
    end

    comment = Comment.where_content(content)

    assert_response :success
    assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
    assert_equal comment, @comment.comments
  end

  test 'should not create reply if not signed in' do
    content = Faker::Fantasy::Tolkien.poem

    assert_difference 'Comment.count', 0 do
      post comments_url(story_id: @story.id, comment_id: @comment.id, comment: { content: }, format: :turbo_stream)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should update comment' do
    sign_in @user
    content = Faker::Fantasy::Tolkien.poem

    patch comment_url(id: @comment.id, comment: { content: }, format: :turbo_stream)
    @comment.reload

    assert_response :success
    assert_equal I18n.t('comments.notices.successfully_updated'), flash.now[:notice]
    assert_equal content, @comment.content.to_plain_text
  end

  test 'should not update comment if not signed in' do
    patch comment_url(id: @comment.id, comment: { content: Faker::Fantasy::Tolkien.poem }, format: :turbo_stream)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not update comment if signed in as another user' do
    sign_in @stranger
    patch comment_url(id: @comment.id, comment: { content: Faker::Fantasy::Tolkien.poem }, format: :turbo_stream)

    assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  end

  test 'should destroy comment' do
    sign_in @user
    @comment.story

    assert_difference 'Comment.count', -1 do
      delete comment_url(@comment, format: :turbo_stream)
    end

    assert_response :success
    assert_equal I18n.t('comments.notices.successfully_destroyed'), flash[:notice]
  end

  test 'should not destroy comment if not signed in' do
    assert_difference 'Comment.count', 0 do
      delete comment_url(@comment, format: :turbo_stream)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not destroy comment if signed in as another user' do
    sign_in @stranger
    assert_difference 'Comment.count', 0 do
      delete comment_url(@comment, format: :turbo_stream)
    end

    assert_equal I18n.t('comments.alerts.not_the_creator'), flash.now[:alert]
  end
end
