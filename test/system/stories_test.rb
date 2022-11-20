# frozen_string_literal: true

require 'application_system_test_case'

class StoriesTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @story = create(:story, user: @user)
    @new_title = Faker::Movies::HitchhikersGuideToTheGalaxy.quote
    @new_content = Faker::TvShows::BrooklynNineNine.quote
  end

  test 'should create story' do
    sign_in @user
    visit new_story_url

    find("textarea[name='story[title]']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find('#story_content').set(@new_content)
    find("input[type='submit']").click
    new_story = @user.stories.find_by(user: @user, title: @new_title)

    assert new_story
    assert_equal story_url(new_story), current_url
    assert_equal I18n.t('stories.notices.successfully_created'), find('.flash__notice').text
  end

  test 'should cancel creating story' do
    sign_in @user
    visit new_story_url

    find("textarea[name='story[title]']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find('#story_content').set(@new_content)

    alert_text = accept_confirm do
      find("a[type='cancel']").click
    end
    assert_equal I18n.t('are_you_sure_changes_unsaved'), alert_text
    assert_not @user.stories.find_by(user: @user, title: @new_title)
    assert_not has_css?('.flash__message')
  end

  test 'should update story with turbo-frames' do
    sign_in @user
    visit story_url(@story)

    find("a[type='edit']").click
    find("textarea[name='story[title]']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find('#story_content').set(@new_content)
    find("input[type='submit']").click

    @story.reload
    assert_equal @new_title, @story.title
    assert_equal @new_content, @story.content.to_plain_text
    assert_equal I18n.t('stories.notices.successfully_updated'), find('.flash__notice').text
  end

  test 'should see edit and delete buttons if creator in the show page' do
    sign_in @user
    visit story_url(@story)

    assert has_css?("a[type='edit']")
    assert has_css?("a[type='delete']")
  end

  # TODO: fix this - remove @rails/ujs and replace link_to delete with buttons
  # test 'should destroy story' do
  #   sign_in @user
  #   story_id = @story.id
  #   visit story_url(@story)

  #   alert_text = accept_confirm do
  #     find("a[type='delete']").click
  #   end
  #   assert_equal I18n.t('are_you_sure_delete'), alert_text
  #   assert_equal I18n.t('stories.notices.successfully_destroyed'), find('.flash__notice').text
  #   assert_not Story.find_by(id: story_id)
  # end
end
