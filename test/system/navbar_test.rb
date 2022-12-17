# frozen_string_literal: true

require 'application_system_test_case'

class NavbarTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    visit root_url

    @navbar = find('#navbar')
  end

  test 'should show relevant buttons based on authentication' do
    assert @navbar.has_css?('#navbar-home')
    assert @navbar.has_css?('#navbar-new-story')

    @navbar.find('.dropdown-toggle').click

    assert @navbar.has_css?('#navbar-sign-up')
    assert @navbar.has_css?('#navbar-log-in')
    assert_not @navbar.has_css?('#navbar-usepage')
    assert_not @navbar.has_css?('#navbar-log-out')

    sign_in create(:user)
    visit root_url

    assert @navbar.has_css?('#navbar-home')
    assert @navbar.has_css?('#navbar-new-story')

    @navbar.find('.dropdown-toggle').click

    assert_not @navbar.has_css?('#navbar-sign-up')
    assert_not @navbar.has_css?('#navbar-log-in')
    assert @navbar.has_css?('#navbar-userpage')
    assert @navbar.has_css?('#navbar-log-out')
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
    @navbar.find('.dropdown-toggle').click
    @navbar.find('#navbar-sign-up').click

    assert_equal new_user_registration_url, current_url
  end

  test 'log_in link works' do
    @navbar.find('.dropdown-toggle').click
    @navbar.find('#navbar-log-in').click

    assert_equal new_user_session_url, current_url
  end

  test 'profile link works' do
    user = create(:user)
    sign_in user
    visit root_url

    @navbar.find('.dropdown-toggle').click
    @navbar.find('#navbar-userpage').click

    assert_equal user_url(user.username), current_url
  end

  test 'log_out link works' do
    sign_in create(:user)
    visit root_url

    @navbar.find('.dropdown-toggle').click
    @navbar.find('#navbar-log-out').click

    assert_equal root_url, current_url

    @navbar.find('.dropdown-toggle').click
    assert_not @navbar.has_css?('#navbar-log-out')
  end
end
