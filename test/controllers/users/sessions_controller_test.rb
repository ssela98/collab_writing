# frozen_string_literal: true

require 'test_helper'

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test 'create with username should work' do
      user = User.create(email: 'bla@nowyouwrite.com', username: 'username', password: 'password')
      user.confirm

      post user_session_path(user: { username: user.username, password: user.password })

      assert_equal user, @controller.current_user
    end

    test 'create without username should fail' do
      user = User.create(email: 'bla@nowyouwrite.com', username: 'username', password: 'password')
      user.confirm

      post user_session_path(user: { password: user.password })

      assert_nil @controller.current_user
    end
  end
end
