# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string(24)       not null
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create' do
    user = User.create(email: Faker::Internet.email, username: Faker::Internet.username,
                       password: Faker::Internet.password)

    assert user.valid?
  end

  test 'should not create without username and should return validation error' do
    user = User.create(email: Faker::Internet.email, password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ["Username can't be blank"], user.errors.full_messages
  end

  test 'should not create with too long username and should return validation error' do
    user = User.create(email: Faker::Internet.email, username: ('a'..'z').to_a.sample(25).join,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ['Username is too long (maximum is 24 characters)'], user.errors.full_messages
  end

  test 'should not create with existing username and should return validation error' do
    username = Faker::Internet.username
    create(:user, username:)

    user = User.create(email: Faker::Internet.email, username:,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ['Username has already been taken'], user.errors.full_messages
  end

  test 'should not create with too long email fails and should return validation error' do
    user = User.create(email: "#{'a' * 200}@email.com", username: Faker::Internet.username,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ['Email is too long (maximum is 200 characters)'], user.errors.full_messages
  end

  test 'stories relationship works' do
    user = create(:user)
    story = create(:story, user:)

    assert_equal [story], user.stories
  end

  test 'comments relationship works' do
    user = create(:user)
    comment = create(:comment, user:)

    assert_equal [comment], user.comments
  end

  test 'destroying should destroy stories and comments' do
    user = create(:user)
    story_1 = create(:story, user:)
    story_2 = create(:story, user:)
    comment = create(:comment, user:)

    assert_difference 'Story.count', -2 do
      assert_difference 'Comment.count', -1 do
        user.destroy
      end
    end
  end
end
