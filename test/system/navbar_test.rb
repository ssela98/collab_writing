# frozen_string_literal: true

require 'application_system_test_case'

class NavbarTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  
  setup do
    visit root_url

    @navbar = find('#navbar')
  end

  test 'should show relevant buttons based on authentication' do
    assert @navbar.has_link?(I18n.t('home'))
    assert @navbar.has_link?(I18n.t('stories.new_story'))
    assert @navbar.has_link?(I18n.t('users.sign_up'))
    assert @navbar.has_link?(I18n.t('users.log_in'))
    assert_not @navbar.has_link?(I18n.t('users.log_out'))

    sign_in create(:user)
    visit root_url

    assert @navbar.has_link?(I18n.t('home'))
    assert @navbar.has_link?(I18n.t('stories.new_story'))
    assert_not @navbar.has_link?(I18n.t('users.sign_up'))
    assert_not @navbar.has_link?(I18n.t('users.log_in'))
    assert @navbar.has_link?(I18n.t('users.log_out'))
  end

  test 'home link works' do
    @navbar.find('#navbar-home').click

    assert_equal root_url, current_url
  end

  test 'new_story link works' do
    sign_in create(:user)
    @navbar.find('#navbar-new-story').click

    assert_equal new_story_url, current_url
  end

  test 'sign_up link works' do
    @navbar.find('#navbar-sign-up').click

    assert_equal new_user_registration_url, current_url
  end

  test 'log_in link works' do
    @navbar.find('#navbar-sign-in').click

    assert_equal new_user_session_url, current_url
  end

  # TODO: fix this (perhaps it'd be wiser to get rid of jquery
  # and replace link_to method: :delete with buttons)
  # test 'log_out link works' do
  #   sign_in create(:user)
  #   visit root_url

  #   @navbar.find('#navbar-log-out').click

  #   assert_equal root_url, current_url
  #   assert_not @navbar.has_link?(I18n.t('users.log_out'))
  # end
end
