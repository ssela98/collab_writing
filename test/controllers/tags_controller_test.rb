# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @story = create(:story, user: @user)
    @tag = create(:tag)
  end

  test 'should get index' do
    get tags_url

    assert_response :success
  end

  test 'should show tag' do
    get tag_url(@tag.name)

    assert_response :success
  end

  test 'should get new' do
    sign_in @user
    get new_tag_url

    assert_response :success
  end

  test 'should not get new if not signed in' do
    get new_tag_url

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should initialize tag on create' do
    sign_in @user

    post tags_url(story_id: @story.id, tag: { name: Faker::Types.rb_string }, format: :turbo_stream)

    assert_response :success
    assert_equal I18n.t('tags.notices.successfully_created'), flash[:notice]
  end

  test 'should not initialize tag on create if not signed in' do
    post tags_url(story_id: @story.id, tag: { name: Faker::Types.rb_string }, format: :turbo_stream)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not initialize tag on create if signed in as another user and should get forbidden response' do
    sign_in create(:user)
    post tags_url(story_id: @story.id, tag: { name: Faker::Types.rb_string }, format: :turbo_stream)

    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end

  # TODO: add update action
  # test 'should update tag' do
  #   patch tag_url(@tag), params: { tag: { name: @tag.name, story_id: @tag.story_id } }
  #   assert_redirected_to tag_url(@tag)
  # end

  test 'should destroy tag' do
    sign_in @user
    delete tag_url(@tag, format: :turbo_stream)

    assert_response :success
    assert_equal I18n.t('tags.notices.successfully_destroyed'), flash[:notice]
  end

  test 'should not destroy tag if not signed in' do
    delete tag_url(@tag, format: :turbo_stream)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end
end
