# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

module Users
  class SessionTest < ApplicationSystemTestCase
    test 'should sign in' do
      username = Faker::Internet.username
      password = Faker::Internet.password
      user = create(:user, username:, password:)

      visit new_user_session_url

      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: password

      find("input[type='submit']").click

      assert_equal current_url, root_url
      assert_equal 1, user.reload.sign_in_count
    end

    test 'should not sign in without username' do
      username = Faker::Internet.username
      password = Faker::Internet.password
      user = create(:user, username:, password:)

      visit new_user_session_url

      find('#user_password').fill_in with: password

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
      assert_equal 0, user.reload.sign_in_count
    end

    test 'should not sign in without password' do
      username = Faker::Internet.username
      user = create(:user, username:, password: Faker::Internet.password)

      visit new_user_session_url

      find('#user_username').fill_in with: username

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
      assert_equal 0, user.reload.sign_in_count
    end

    test 'should not sign in with invalid password' do
      username = Faker::Internet.username
      create(:user, username:, password: Faker::Internet.password)

      visit new_user_session_url

      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: Faker::Internet.password

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
    end

    test 'should not sign in with non-existing username' do
      visit new_user_session_url

      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password').fill_in with: Faker::Internet.password

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
    end
  end
end
