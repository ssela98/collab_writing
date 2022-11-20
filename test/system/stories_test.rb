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
    find("textarea[name='story[content]']").click
    find("textarea[name='story[content]']").fill_in with: @new_content
    find("input[type='submit']").click
    new_story = @user.stories.find_by(title: @new_title, content: @new_content)

    assert new_story
    assert_equal story_url(new_story), current_url
    assert_equal I18n.t('stories.notices.successfully_created'), find('.flash__notice').text
  end

  test 'should cancel creating story' do
    sign_in @user
    visit new_story_url

    find("textarea[name='story[title]']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find("textarea[name='story[content]']").click
    find("textarea[name='story[content]']").fill_in with: @new_content

    alert_text = accept_confirm do
      find("a[type='cancel']").click
    end
    assert_equal I18n.t('are_you_sure_changes_unsaved'), alert_text
    assert_not @user.stories.find_by(title: @new_title, content: @new_content)
    assert_not has_css?('.flash__message')
  end

  test 'should update story by clicking on the title in the show page' do
    sign_in @user
    visit story_url(@story)

    find("textarea[name='title']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find("textarea[name='story[content]']").click
    find("textarea[name='story[content]']").fill_in with: @new_content
    find("input[type='submit']").click

    @story.reload
    assert_equal @new_title, @story.title
    assert_equal @new_content, @story.content
    assert_equal I18n.t('stories.notices.successfully_updated'), find('.flash__notice').text
  end

  test 'should update story by clicking on the content in the show page' do
    sign_in @user
    visit story_url(@story)

    find("textarea[name='content']").click
    find("textarea[name='story[title]']").fill_in with: @new_title
    find("textarea[name='story[content]']").click
    find("textarea[name='story[content]']").fill_in with: @new_content
    find("input[type='submit']").click

    @story.reload
    assert_equal @new_title, @story.title
    assert_equal @new_content, @story.content
    assert_equal I18n.t('stories.notices.successfully_updated'), find('.flash__notice').text
  end

  test 'should see readonly story if not creator in the show page' do
    sign_in create(:user)
    visit story_url(@story)

    assert_not has_css?("a[type='delete']")
    find("##{dom_id @story}_title").click

    assert_not has_css?("textarea[name='title']")
    assert_not has_css?("textarea[name='story[title]']")
    assert_not has_css?("input[type='submit']")
    assert has_css?("##{dom_id @story}_created_at")
  end

  test 'should see editable story if creator in the show page' do
    sign_in @user
    visit story_url(@story)

    assert has_css?("textarea[name='title']")
    assert has_css?("textarea[name='content']")
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
