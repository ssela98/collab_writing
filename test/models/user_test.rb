# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'creating user with username works' do
    user = User.create(email: Faker::Internet.email, username: Faker::Internet.username,
                       password: Faker::Internet.password)

    assert user.valid?
  end

  test 'creating user without username should not work' do
    user = User.create(email: Faker::Internet.email, password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ["Username can't be blank"], user.errors.full_messages
  end

  test 'creating user with too long username should not work' do
    user = User.create(email: Faker::Internet.email, username: ('a'..'z').to_a.sample(25).join,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ['Username is too long (maximum is 24 characters)'], user.errors.full_messages
  end
end
