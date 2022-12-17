# frozen_string_literal: true

require 'test_helper'

class StoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @stranger = create(:user)
    @story = create(:story, user: @user)
  end

  test 'should get index' do
    get stories_url

    assert_response :success
  end

  test 'should get index with user stories if signed in' do
    sign_in @user
    get stories_url

    assert_response :success
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

    story = Story.find_by(user: @user, title:)

    assert_redirected_to story_url(story)
    assert_equal I18n.t('stories.notices.successfully_created'), flash[:notice]
    assert_equal @user, story.user
    assert_equal title, story.title
    assert_equal content, story.content.to_plain_text
  end

  test 'should create story_tags and tags on create' do
    sign_in @user
    title = Faker::Movies::HitchhikersGuideToTheGalaxy.quote
    content = Faker::TvShows::BrooklynNineNine.quote

    assert_difference 'StoryTag.count', 2 do
      assert_difference 'Tag.count', 2 do
        post stories_url(story: { title:, content: }, story_tag_names: %w[new_tag new_tag_2])
      end
    end

    story = Story.where_content(content).take

    assert_equal %w[new_tag new_tag_2], story.story_tags.joins(:tag).pluck('tags.name')
  end

  test 'should create or destroy story_tags and tags on update' do
    sign_in @user

    assert_difference 'StoryTag.count', 2 do
      assert_difference 'Tag.count', 2 do
        patch story_url(@story, story_tag_names: %w[new_tag new_tag_2], format: :turbo_stream)
      end
    end

    assert_equal %w[new_tag new_tag_2], @story.story_tags.joins(:tag).pluck('tags.name')

    assert_difference 'StoryTag.count', -1 do
      assert_difference 'Tag.count', -1 do
        patch story_url(@story, story_tag_names: ['new_tag'], format: :turbo_stream)
      end
    end

    assert_equal ['new_tag'], @story.story_tags.joins(:tag).pluck('tags.name')
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
    get edit_story_url(@story, format: :turbo_stream)

    assert_response :success
  end

  test 'should not get edit if signed in as another user' do
    sign_in @stranger
    get edit_story_url(@story, format: :turbo_stream)

    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end

  test 'should not get edit if not signed in' do
    get edit_story_url(@story, format: :turbo_stream)

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
    assert_equal content, @story.content.to_plain_text
    assert_equal visible, @story.visible
  end

  test 'should not update story if not signed in' do
    patch story_url(@story), params: { story: { title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote }, format: :turbo_stream }

    assert_redirected_to new_user_session_path
    assert_equal I18n.t('devise.failure.unauthenticated'), flash[:alert]
  end

  test 'should not update if signed in as another user and should get forbidden response' do
    sign_in @stranger
    patch story_url(@story), params: { story: { title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote }, format: :turbo_stream }

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
    assert_difference 'Story.count', 0 do
      delete story_url(@story)
    end

    assert_equal I18n.t('stories.alerts.not_the_creator'), flash.now[:alert]
  end
end
