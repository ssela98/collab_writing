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
require 'faker'

FactoryBot.define do
  factory :user do
    username { "username_#{(1..50).to_a.sample(7).join}" }
    email { "#{username}@#{Faker::Internet.domain_name}".downcase }
    password { Faker::Internet.password }
    confirmed_at { Time.current.utc }
    confirmation_token { nil }

    trait :not_confirmed do
      confirmed_at { nil }
      confirmation_token { Digest::SHA1.hexdigest(('a'..'z').to_a.sample(4).join) }
    end
  end
end
