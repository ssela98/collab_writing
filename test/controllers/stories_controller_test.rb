# frozen_string_literal: true

require 'test_helper'

class StoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @stranger = create(:user)
    @story = create(:story, user: @user)
  end

  test 'should get new' do
    sign_in @user
    get new_story_url

    assert_response :success
  end

  test 'should not get new if not signed in and should get redirected to sign in' do
    get new_story_url

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should create' do
    sign_in @user
    title = Faker::Movies::HitchhikersGuideToTheGalaxy.quote
    content = Faker::TvShows::BrooklynNineNine.quote

    assert_difference 'Story.count', 1 do
      post stories_url, params: { story: { title:, content: } }
    end

    story = Story.find_by(user: @user, title:, content:)

    assert_redirected_to story_url(story)
    assert_equal I18n.t('stories.notices.successfully_created'), flash[:notice]
    assert_equal @user, story.user
    assert_equal title, story.title
    assert_equal content, story.content
  end

  test 'should not create story if not signed in' do
    assert_difference 'Story.count', 0 do
      post stories_url, params: { story: { title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote, content: Faker::TvShows::BrooklynNineNine.quote } }
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should show story' do
    get story_url(@story)

    assert_response :success
  end

  test 'should get edit' do
    sign_in @user
    get edit_story_url(@story)

    assert_response :success
  end

  test 'should not get edit if signed in as another user and should get forbidden response' do
    sign_in @stranger
    get edit_story_url(@story)

    assert_response :forbidden
    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end

  test 'should not get edit if not signed in' do
    get edit_story_url(@story)

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should update story' do
    sign_in @user
    title = Faker::Movies::HitchhikersGuideToTheGalaxy.quote
    content = Faker::TvShows::BrooklynNineNine.quote
    visible = false

    patch story_url(@story), params: { story: { title:, content:, visible:, }, format: :turbo_stream }
    @story.reload

    assert_response :success
    assert_equal I18n.t('stories.notices.successfully_updated'), flash.now[:notice]
    assert_equal title, @story.title
    assert_equal content, @story.content
    assert_equal visible, @story.visible
  end

  test 'should not update story if not signed in' do
    patch story_url(@story), params: { story: { title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote } }

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not update if signed in as another user and should get forbidden response' do
    sign_in @stranger
    patch story_url(@story), params: { story: { title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote } }

    assert_response :forbidden
    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end

  test 'should destroy story' do
    sign_in @user

    assert_difference 'Story.count', -1 do
      delete story_url(@story)
    end

    assert_redirected_to root_path
    assert_equal I18n.t('stories.notices.successfully_destroyed'), flash[:notice]
  end

  test 'should not destroy story if not signed in' do
    assert_difference 'Story.count', 0 do
      delete story_url(@story)
    end

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not destroy if signed in as another user and should get forbidden response' do
    sign_in @stranger
    delete story_url(@story)

    assert_response :forbidden
    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end
end
