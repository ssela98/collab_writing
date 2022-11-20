# frozen_string_literal: true

require 'test_helper'

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'should create' do
      user = create(:user)

      post user_session_path(user: { username: user.username, password: user.password })

      assert_equal user, @controller.current_user
      assert_redirected_to root_path
      assert_equal I18n.t('devise.sessions.signed_in'), flash[:notice]
    end

    test 'should not get new if already signed in' do
      user = create(:user)
      sign_in user

      get new_user_session_path

      assert_redirected_to root_path
      assert_equal I18n.t('devise.failure.already_authenticated'), flash[:alert]
    end

    test 'should not create if already signed in' do
      user = create(:user)
      sign_in user

      post user_session_path(user: { username: user.username, password: user.password })

      assert_redirected_to root_path
      assert_equal I18n.t('devise.failure.already_authenticated'), flash[:alert]
    end

    test 'should not create without username' do
      user = create(:user)

      post user_session_path(user: { password: user.password })

      assert_equal I18n.t('devise.failure.invalid', authentication_keys: 'Username'), flash[:alert]
      assert_nil @controller.current_user
    end

    test 'should not create without password' do
      user = create(:user)

      post user_session_path(user: { username: user.username })

      assert_equal I18n.t('devise.failure.invalid', authentication_keys: 'Username'), flash[:alert]
      assert_nil @controller.current_user
    end

    test 'should not create with unmatching password' do
      user = create(:user)

      post user_session_path(user: { username: user.username, password: Faker::Internet.password })

      assert_equal I18n.t('devise.failure.invalid', authentication_keys: 'Username'), flash[:alert]
      assert_nil @controller.current_user
    end

    test 'should not create with non-existing username' do
      user = create(:user)

      post user_session_path(user: { username: ('a'..'z').to_a.sample(25).join, password: user.password })

      assert_equal I18n.t('devise.failure.invalid', authentication_keys: 'Username'), flash[:alert]
      assert_nil @controller.current_user
    end
  end
end
