# frozen_string_literal: true

require 'application_system_test_case'

module Users
  class RegistrationsTest < ApplicationSystemTestCase
    # TODO: uncomment when you reenable user :registerable
    # test 'should register' do
    #   visit new_user_registration_url

    #   email = Faker::Internet.email
    #   password = Faker::Internet.password

    #   find('#user_email').fill_in with: email
    #   find('#user_username').fill_in with: Faker::Internet.username
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 1 do
    #     find("input[type='submit']").click
    #   end

    #   assert_includes current_url, new_user_session_path
    #   assert_equal I18n.t('devise.registrations.signed_up_but_unconfirmed'), find('.flash__notice').text
    #   assert User.find_by(email:)
    # end

    # test 'should not register without email' do
    #   visit new_user_registration_url

    #   username = Faker::Internet.username
    #   password = Faker::Internet.password

    #   find('#user_username').fill_in with: username
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 0 do
    #     find("input[type='submit']").click
    #   end

    #   # assert_equal new_user_registration_url, current_url # TODO: why does this fail?
    #   assert_equal 'Email can\'t be blank', find('#new_user_email_errors > li').text
    #   assert_not User.find_by(username:)
    # end

    # test 'should not register without username' do
    #   visit new_user_registration_url

    #   email = Faker::Internet.email
    #   password = Faker::Internet.password

    #   find('#user_email').fill_in with: email
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 0 do
    #     find("input[type='submit']").click
    #   end

    #   # assert_equal new_user_registration_url, current_url # TODO: why does this fail?
    #   assert_equal 'Username can\'t be blank', find('#new_user_username_errors > li').text
    #   assert_not User.find_by(email:)
    # end

    # test 'should not register with too long email' do
    #   visit new_user_registration_url

    #   username = Faker::Internet.username
    #   password = Faker::Internet.password

    #   find('#user_email').fill_in with: "#{'a' * 200}@email.com"
    #   find('#user_username').fill_in with: username
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 0 do
    #     find("input[type='submit']").click
    #   end

    #   # assert_equal new_user_registration_url, current_url # TODO: why does this fail?
    #   assert_equal 'Email is too long (maximum is 200 characters)', find('#new_user_email_errors > li').text
    #   assert_not User.find_by(username:)
    # end

    # test 'should not register with too long username' do
    #   visit new_user_registration_url

    #   email = Faker::Internet.email
    #   password = Faker::Internet.password

    #   find('#user_email').fill_in with: email
    #   find('#user_username').fill_in with: ('a'..'z').to_a.sample(25).join
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 0 do
    #     find("input[type='submit']").click
    #   end

    #   # assert_equal new_user_registration_url, current_url # TODO: why does this fail?
    #   assert_equal 'Username is too long (maximum is 24 characters)', find('#new_user_username_errors > li').text
    #   assert_not User.find_by(email:)
    # end

    # test 'should not register with existing username' do
    #   visit new_user_registration_url

    #   username = Faker::Internet.username
    #   create(:user, username:)

    #   password = Faker::Internet.password

    #   find('#user_email').fill_in with: Faker::Internet.email
    #   find('#user_username').fill_in with: username
    #   find('#user_password').fill_in with: password
    #   find('#user_password_confirmation').fill_in with: password

    #   assert_difference 'User.count', 0 do
    #     find("input[type='submit']").click
    #   end

    #   # assert_equal new_user_registration_url, current_url # TODO: why does this fail?
    #   assert_equal 'Username has already been taken', find('#new_user_username_errors > li').text
    #   assert_equal 1, User.where(username:).count
    # end
  end
end
