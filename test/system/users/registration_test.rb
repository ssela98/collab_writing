# # frozen_string_literal: true

# require 'test_helper'
# require 'application_system_test_case'

# module Users
#   class RegistrationTest < ApplicationSystemTestCase
#     test 'should register' do
#       visit new_user_registration_url

#       email = Faker::Internet.email
#       password = Faker::Internet.password

#       find('#user_email').fill_in with: email
#       find('#user_username').fill_in with: Faker::Internet.username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 1 do
#         find("input[type='submit']").click
#       end

#       assert_includes current_url, new_user_session_path
#       assert User.find_by(email:)
#     end

#     test 'should not register without email' do
#       visit new_user_registration_url

#       username = Faker::Internet.username
#       password = Faker::Internet.password

#       find('#user_username').fill_in with: username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(username:)
#     end

#     test 'should not register without username' do
#       visit new_user_registration_url

#       email = Faker::Internet.email
#       password = Faker::Internet.password

#       find('#user_email').fill_in with: email
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(email:)
#     end

#     test 'should not register without password' do
#       visit new_user_registration_url

#       email = Faker::Internet.email

#       find('#user_email').fill_in with: email
#       find('#user_username').fill_in with: Faker::Internet.username
#       find('#user_password_confirmation').fill_in with: Faker::Internet.password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(email:)
#     end

#     test 'should not register with unmatching password confirmation' do
#       visit new_user_registration_url

#       email = Faker::Internet.email

#       find('#user_email').fill_in with: email
#       find('#user_username').fill_in with: Faker::Internet.username
#       find('#user_password').fill_in with: Faker::Internet.password
#       find('#user_password_confirmation').fill_in with: Faker::Internet.password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(email:)
#     end

#     test 'should not register with too long email' do
#       visit new_user_registration_url

#       username = Faker::Internet.username
#       password = Faker::Internet.password

#       find('#user_email').fill_in with: "#{'a' * 200}@email.com"
#       find('#user_username').fill_in with: username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(username:)
#     end

#     test 'should not register with too long username' do
#       visit new_user_registration_url

#       email = Faker::Internet.email
#       password = Faker::Internet.password

#       find('#user_email').fill_in with: email
#       find('#user_username').fill_in with: ('a'..'z').to_a.sample(25).join
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(email:)
#     end

#     test 'should not register with badly formatted email' do
#       visit new_user_registration_url

#       username = Faker::Internet.username
#       password = Faker::Internet.password

#       find('#user_email').fill_in with: 'bad_email'
#       find('#user_username').fill_in with: username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_not User.find_by(username:)
#     end

#     test 'should not register with existing email' do
#       visit new_user_registration_url

#       email = Faker::Internet.email
#       create(:user, email:)

#       password = Faker::Internet.password

#       find('#user_email').fill_in with: email
#       find('#user_username').fill_in with: Faker::Internet.username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_equal 1, User.where(email:).count
#     end

#     test 'should not register with existing username' do
#       visit new_user_registration_url

#       username = Faker::Internet.username
#       create(:user, username:)

#       password = Faker::Internet.password

#       find('#user_email').fill_in with: Faker::Internet.email
#       find('#user_username').fill_in with: username
#       find('#user_password').fill_in with: password
#       find('#user_password_confirmation').fill_in with: password

#       assert_difference 'User.count', 0 do
#         find("input[type='submit']").click
#       end

#       # TODO: assert flash messages when they're introduced
#       assert_equal new_user_registration_url, current_url
#       assert_equal 1, User.where(username:).count
#     end
#   end
# end
