# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

module Users
  class RegistrationTest < ApplicationSystemTestCase
    test 'registration works' do
      visit new_user_registration_url

      email = Faker::Internet.email
      password = Faker::Internet.password

      find('#user_email').fill_in with: email
      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 1 do
        find("input[type='submit']").click
      end

      assert_includes current_url, new_user_session_path
      assert User.find_by(email:)
    end

    test 'registration without email fails' do
      visit new_user_registration_url

      username = Faker::Internet.username
      password = Faker::Internet.password

      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(username:)
    end

    test 'registration without username fails' do
      visit new_user_registration_url

      email = Faker::Internet.email
      password = Faker::Internet.password

      find('#user_email').fill_in with: email
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(email:)
    end

    test 'registration without password fails' do
      visit new_user_registration_url

      email = Faker::Internet.email

      find('#user_email').fill_in with: email
      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password_confirmation').fill_in with: Faker::Internet.password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(email:)
    end

    test 'registration with unmatching password confirmation fails' do
      visit new_user_registration_url

      email = Faker::Internet.email

      find('#user_email').fill_in with: email
      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password').fill_in with: Faker::Internet.password
      find('#user_password_confirmation').fill_in with: Faker::Internet.password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(email:)
    end

    test 'registration with too long email fails' do
      visit new_user_registration_url

      username = Faker::Internet.username
      password = Faker::Internet.password

      find('#user_email').fill_in with: "#{ 'a' * 200 }@email.com"
      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(username:)
    end

    test 'registration with too long username fails' do
      visit new_user_registration_url

      email = Faker::Internet.email
      password = Faker::Internet.password

      find('#user_email').fill_in with: email
      find('#user_username').fill_in with: ('a'..'z').to_a.sample(25).join
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(email:)
    end

    test 'registration with badly formatted email fails' do
      visit new_user_registration_url

      username = Faker::Internet.username
      password = Faker::Internet.password

      find('#user_email').fill_in with: 'bad_email'
      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_not User.find_by(username:)
    end

    test 'registration with existing email fails' do
      visit new_user_registration_url

      email = Faker::Internet.email
      create(:user, email:)

      password = Faker::Internet.password

      find('#user_email').fill_in with: email
      find('#user_username').fill_in with: Faker::Internet.username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_equal 1, User.where(email:).count
    end

    test 'registration with existing username fails' do
      visit new_user_registration_url

      username = Faker::Internet.username
      create(:user, username:)

      password = Faker::Internet.password

      find('#user_email').fill_in with: Faker::Internet.email
      find('#user_username').fill_in with: username
      find('#user_password').fill_in with: password
      find('#user_password_confirmation').fill_in with: password

      assert_difference 'User.count', 0 do
        find("input[type='submit']").click
      end

      # TODO: assert flash messages when they're introduced
      assert_equal new_user_registration_url, current_url
      assert_equal 1, User.where(username:).count
    end
  end
end
