# # frozen_string_literal: true

# require 'test_helper'

# module Users
#   class RegistrationsControllerTest < ActionDispatch::IntegrationTest
#     # TODO: uncomment when you reenable user :registerable
#     test 'create sends email and redirects to login' do
#       email = Faker::Internet.email
#       password = Faker::Internet.password
#       sign_up_params = { email:, username: Faker::Internet.username, password:,
#         password_confirmation: password }

#       post user_registration_path(user: sign_up_params)
#       assert_redirected_to new_user_session_path

#       user = User.find_by(email:)
#       mail = ActionMailer::Base.deliveries.last

#       assert_equal [sign_up_params[:email]], mail.to
#       assert_equal [Devise.mailer_sender], mail.from
#       assert_equal 'Confirmation instructions', mail.subject
#       assert mail.decoded.include?(user_confirmation_path(confirmation_token: user.confirmation_token))
#     end

#     test 'create without email fails' do
#       username = Faker::Internet.username
#       password = Faker::Internet.password
#       sign_up_params = { username: Faker::Internet.username, password:,
#         password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(username:)
#     end

#     test 'create without username fails' do
#       email = Faker::Internet.email
#       password = Faker::Internet.password
#       sign_up_params = { email:, password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(email:)
#     end

#     test 'create without password fails' do
#       email = Faker::Internet.email
#       sign_up_params = { email:, username: Faker::Internet.username,
#         password_confirmation: Faker::Internet.password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(email:)
#     end

#     test 'create with unmatching password confirmation fails' do
#       email = Faker::Internet.email
#       password = Faker::Internet.password
#       sign_up_params = { email:, username: Faker::Internet.username,
#         password:, password_confirmation: Faker::Internet.password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(email:)
#     end

#     test 'create with too long email fails' do
#       username = Faker::Internet.username
#       password = Faker::Internet.password
#       sign_up_params = { email: "#{'a' * 200}@email.com", username:,
#         password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(username:)
#     end

#     test 'create with too long username fails' do
#       email = Faker::Internet.email
#       password = Faker::Internet.password
#       sign_up_params = { email:, username: 'a' * 25,
#         password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(email:)
#     end

#     test 'create with badly formatted email fails' do
#       username = Faker::Internet.username
#       password = Faker::Internet.password
#       sign_up_params = { email: 'bad_email', username:,
#         password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_not User.find_by(username:)
#     end

#     test 'create with existing email fails' do
#       email = Faker::Internet.email
#       create(:user, email:)
#       password = Faker::Internet.password
#       sign_up_params = { email:, username: Faker::Internet.username,
#         password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_equal 1, User.where(email:).count
#     end

#     test 'create with existing username fails' do
#       username = Faker::Internet.username
#       create(:user, username:)
#       password = Faker::Internet.password
#       sign_up_params = { email: Faker::Internet.email, username:,
#         password:, password_confirmation: password }

#       assert_difference 'User.count', 0 do
#         post user_registration_path(user: sign_up_params)
#       end

#       # assert flash messages when they're introduced
#       assert_equal 1, User.where(username:).count
#     end
#   end
# end
