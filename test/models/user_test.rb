require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'creating user with username works' do
    user = User.create(email: 'user@email.com', username: 'user', password: 'password')

    assert user.valid?
  end

  test 'creating user without username should not work' do
    user = User.create(email: 'user@email.com', password: 'password')

    assert_not user.valid?
    assert_equal ["Username can't be blank"], user.errors.full_messages
  end

  test 'creating user with too long username should not work' do
    user = User.create(email: 'user@email.com', username: 'a' * 25, password: 'password')

    assert_not user.valid?
    assert_equal ['Username is too long (maximum is 24 characters)'], user.errors.full_messages
  end
end
