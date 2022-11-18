# frozen_string_literal: true

require 'test_helper'

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test 'create works' do
      user = create(:user)

      post user_session_path(user: { username: user.username, password: user.password })

      assert_equal user, @controller.current_user
      assert_redirected_to root_path
    end

    test 'create without username fails' do
      user = create(:user)

      post user_session_path(user: { password: user.password })

      # TODO: assert flash messages when they're introduced
      assert_nil @controller.current_user
    end

    test 'create without password fails' do
      user = create(:user)

      post user_session_path(user: { username: user.username })

      # TODO: assert flash messages when they're introduced
      assert_nil @controller.current_user
    end

    test 'create with unmatching password fails' do
      user = create(:user)

      post user_session_path(user: { username: user.username, password: Faker::Internet.password })

      # TODO: assert flash messages when they're introduced
      assert_nil @controller.current_user
    end

    test 'create with non-existing username fails' do
      user = create(:user)

      post user_session_path(user: { username: ('a'..'z').to_a.sample(25).join, password: user.password })

      # TODO: assert flash messages when they're introduced
      assert_nil @controller.current_user
    end
  end
end
