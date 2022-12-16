# frozen_string_literal: true

require 'test_helper'

class PinsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @story = create(:story, user: @user)
    @comment = create(:comment, story: @story)
  end

  test 'should get index' do
    get pins_url(story_id: @story.id)

    assert_response :success
  end

  test 'should create pin' do
    sign_in @user

    assert_difference 'Pin.count', 1 do
      post pins_url(pin: { story_id: @story.id, comment_id: @comment.id }, format: :turbo_stream)
    end

    assert_response :success
    assert_equal I18n.t('pins.notices.successfully_created'), flash[:notice]
  end

  test 'should not create pin if not signed in' do
    assert_difference 'Pin.count', 0 do
      post pins_url(pin: { story_id: @story.id, comment_id: @comment.id }, format: :turbo_stream)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  # TODO: add edit form
  # test 'should get edit' do
  #   get edit_pin_url(@pin)
  #   assert_response :success
  # end

  # TODO: add update action
  # test 'should update pin' do
  #   patch pin_url(@pin), params: { pin: {  } }
  #   assert_redirected_to pin_url(@pin)
  # end

  test 'should destroy pin' do
    sign_in @user
    pin = create(:pin, comment: @comment)

    assert_difference('Pin.count', -1) do
      delete pin_url(pin, format: :turbo_stream)
    end

    assert_response :success
    assert_equal I18n.t('pins.notices.successfully_destroyed'), flash[:notice]
  end

  test 'should not destroy pin if not signed in' do
    pin = create(:pin, comment: @comment)

    assert_difference('Pin.count', 0) do
      delete pin_url(pin, format: :turbo_stream)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not destroy pin if signed in as another user and should get forbidden response' do
    sign_in create(:user)
    pin = create(:pin, comment: @comment)

    assert_difference('Pin.count', 0) do
      delete pin_url(pin, format: :turbo_stream)
    end

    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end
end
