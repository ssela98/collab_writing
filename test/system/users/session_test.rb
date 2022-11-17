require "test_helper"
require "application_system_test_case"

class Users::SessionTest < ApplicationSystemTestCase
  test 'signing in with username works' do
    username = Faker::Internet.username
    password = Faker::Internet.password
    user = User.create(email: Faker::Internet.email, username: username, password: password)
    user.confirm

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
    user = User.create(email: Faker::Internet.email, username: username, password: password)
    user.confirm

    visit new_user_session_url

    find('#user_password').fill_in with: password

    find("input[type='submit']").click

    # TODO: assert flash messages when they're introduced
    assert_equal new_user_session_url, current_url
    assert_equal 0, user.reload.sign_in_count
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
