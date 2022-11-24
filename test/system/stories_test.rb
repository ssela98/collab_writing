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
      find("a[type='cancel']").click # TODO: fix this
    end
    assert_equal I18n.t('are_you_sure_changes_unsaved'), alert_text
    assert_not @user.stories.find_by(user: @user, title: @new_title)
    assert_not has_css?('.flash__message')
  end

  test 'should update story with turbo-frames' do
    sign_in @user
    visit story_url(@story)

    find("##{dom_id(@story)}").find("a[type='edit']").click
    find("##{dom_id(@story)}").find("textarea[name='story[title]']").click.fill_in with: @new_title
    find("##{dom_id(@story)}").find('#story_content').click.set(@new_content)
    find("##{dom_id(@story)}").find("input[type='submit']").click

    @story.reload
    assert_equal @new_title, @story.title
    assert_equal @new_content, @story.content.to_plain_text
    assert_equal I18n.t('stories.notices.successfully_updated'), find('.flash__notice').text
  end

  test 'should see edit or delete buttons if creator of the story' do
    sign_in @user
    visit story_url(@story)

    story = find("##{dom_id(@story)}")

    assert story.has_css?('.hideable-buttons')
  end

  test 'should destroy story' do
    sign_in @user
    story_id = @story.id
    visit story_url(@story)

    alert_text = accept_confirm do
      find("##{dom_id(@story)}").find('.hideable-buttons').find("form[class='button_to']").find("button[type='submit']").click
    end

    assert_equal I18n.t('are_you_sure_delete'), alert_text
    assert_equal I18n.t('stories.notices.successfully_destroyed'), find('.flash__notice').text
    assert_not Story.find_by(id: story_id)
  end
end
