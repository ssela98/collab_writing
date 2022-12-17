# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test 'should get profile' do
    get user_url(@user.username)

    assert_response :success
  end

  test 'should get user stories' do
    get stories_user_url(@user.username)

    assert_response :success
  end

  test 'should get user comments' do
    get comments_user_url(@user.username)

    assert_response :success
  end

  # TODO: add favouriting feature
  # test 'should get user favourites' do
  #   get favourites_user_url(@user.username)

  #   assert_response :success
  # end
end
