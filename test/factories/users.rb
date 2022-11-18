# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    confirmed_at { Time.current.utc }
    confirmation_token { nil }

    trait :not_confirmed do
      confirmed_at { nil }
      confirmation_token { Digest::SHA1.hexdigest(('a'..'z').to_a.sample(4).join) }
    end
  end
end
