# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

module Users
  class SessionTest < ApplicationSystemTestCase
    test 'signing in works' do
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

    test 'signing in without username fails' do
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

    test 'signing in without password fails' do
      username = Faker::Internet.username
      user = create(:user, username:, password: Faker::Internet.password)

      visit new_user_session_url

      find('#user_username').fill_in with: username

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
      assert_equal 0, user.reload.sign_in_count
    end

    test 'signing in with invalid password fails' do
      username = Faker::Internet.username
      create(:user, username:, password: Faker::Internet.password)

      visit new_user_session_url

      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: Faker::Internet.password

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
    end

    test 'signing in with non-existing username fails' do
      visit new_user_session_url

      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password').fill_in with: Faker::Internet.password

      find("input[type='submit']").click

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_session_url, current_url
    end
  end
end
