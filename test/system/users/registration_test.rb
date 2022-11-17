require "test_helper"
require "application_system_test_case"

class Users::RegistrationTest < ApplicationSystemTestCase
  test 'registration with username works' do
    visit new_user_registration_url

    email = Faker::Internet.email
    password = Faker::Internet.password

    find('#user_email').fill_in with: email
    find('#user_username').fill_in with: Faker::Internet.username
    find('#user_password').fill_in with: password
    find('#user_password_confirmation').fill_in with: password

    find("input[type='submit']").click

    assert_includes current_url, new_user_session_path
    assert User.find_by(email: email)
  end

  test 'registration without username fails' do
    visit new_user_registration_url

    email = Faker::Internet.email
    password = Faker::Internet.password

    find('#user_email').fill_in with: email
    find('#user_password').fill_in with: password
    find('#user_password_confirmation').fill_in with: password

    find("input[type='submit']").click

    # TODO: assert flash messages when they're introduced
    assert_equal new_user_registration_url, current_url
    assert_not User.find_by(email: email)
  end

  test 'registration with too long username fails' do
    visit new_user_registration_url

    email = Faker::Internet.email
    password = Faker::Internet.password

    find('#user_email').fill_in with: email
    find('#user_username').fill_in with: ('a'..'z').to_a.sample(25).join
    find('#user_password').fill_in with: password
    find('#user_password_confirmation').fill_in with: password

    find("input[type='submit']").click

    # TODO: assert flash messages when they're introduced
    assert_equal new_user_registration_url, current_url
    assert_not User.find_by(email: email)
  end
end
