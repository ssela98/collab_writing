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
  test 'creating with username works' do
    user = User.create(email: Faker::Internet.email, username: Faker::Internet.username,
                       password: Faker::Internet.password)

    assert user.valid?
  end

  # validatons - create

  test 'creating without username should fail with validation message' do
    user = User.create(email: Faker::Internet.email, password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ["Username can't be blank"], user.errors.full_messages
  end

  test 'creating with too long username should fail with validation message' do
    user = User.create(email: Faker::Internet.email, username: ('a'..'z').to_a.sample(25).join,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ['Username is too long (maximum is 24 characters)'], user.errors.full_messages
  end

  test 'creating with existing username should fail with validation message' do
    username = Faker::Internet.username
    create(:user, username:)

    user = User.create(email: Faker::Internet.email, username:,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ["Username has already been taken"], user.errors.full_messages
  end

  test 'creating with too long email should fail with validation message' do
    user = User.create(email: "#{'a' * 200}@email.com", username: Faker::Internet.username,
                       password: Faker::Internet.password)

    assert_not user.valid?
    assert_equal ["Email is too long (maximum is 200 characters)"], user.errors.full_messages
  end
end
