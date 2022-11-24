# frozen_string_literal: true

require 'test_helper'

module Stories
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @user = create(:user)
      @commentable = create(:story, user: @user)
    end

    test 'should create' do
      sign_in @user
      content = Faker::Fantasy::Tolkien.poem

      assert_difference 'Comment.count', 1 do
        post "/stories/#{@commentable.id}/comments", params: { comment: { content: }, format: :turbo_stream }
      end

      comment = Comment.find_by(user: @user, commentable: @commentable, parent: nil)

      assert_response :success
      assert_equal I18n.t('comments.notices.successfully_created'), flash[:notice]
      assert_equal @user, comment.user
      assert_equal content, comment.content.to_plain_text
      assert_equal @commentable, comment.commentable
      assert_equal [comment], @commentable.comments
    end

    test 'should not create if not signed in' do
      content = Faker::Fantasy::Tolkien.poem

      assert_difference 'Comment.count', 0 do
        post "/stories/#{@commentable.id}/comments", params: { comment: { content: }, format: :turbo_stream }
      end

      assert_redirected_to new_user_session_path
      assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
    end
  end
end
