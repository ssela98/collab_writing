# frozen_string_literal: true

require 'test_helper'

module Comments
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @user = create(:user)
      @commentable = create(:comment, :of_story, user: @user)
    end

    test 'should create' do
      sign_in @user
      content = Faker::Fantasy::Tolkien.poem

      assert_difference 'Comment.count', 1 do
        post comment_comments_url(comment_id: @commentable.id), params: { comment: { content: }, format: :turbo_stream }
      end

      comment = Comment.find_by(user: @user, commentable: @commentable.commentable, parent: @commentable)

      assert_response :success
      assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
      assert_equal @user, comment.user
      assert_equal content, comment.content.to_plain_text
      assert_equal @commentable, comment.parent
      assert_equal @commentable.commentable, comment.commentable
    end

    test 'should not create if not signed in' do
      content = Faker::Fantasy::Tolkien.poem

      assert_difference 'Comment.count', 0 do
        post comment_comments_url(comment_id: @commentable.id), params: { comment: { content: }, format: :turbo_stream }
      end

      assert_redirected_to new_user_session_path
      assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
    end
  end
end
