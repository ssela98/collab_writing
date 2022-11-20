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
    assert @navbar.has_css?('#navbar-sign-up')
    assert @navbar.has_css?('#navbar-log-in')
    assert_not @navbar.has_css?('#navbar-log-out')

    sign_in create(:user)
    visit root_url

    assert @navbar.has_css?('#navbar-home')
    assert @navbar.has_css?('#navbar-new-story')
    assert_not @navbar.has_css?('#navbar-sign-up')
    assert_not @navbar.has_css?('#navbar-log-in')
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
    @navbar.find('#navbar-sign-up').click

    assert_equal new_user_registration_url, current_url
  end

  test 'log_in link works' do
    @navbar.find('#navbar-log-in').click

    assert_equal new_user_session_url, current_url
  end

  # TODO: fix this - remove @rails/ujs and replace link_to delete with buttons
  # test 'log_out link works' do
  #   sign_in create(:user)
  #   visit root_url

  #   @navbar.find('#navbar-log-out').click

  #   assert_equal root_url, current_url
  #   assert_not @navbar.has_css?('#navbar-log-out')
  # end
end
