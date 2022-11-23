# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require Rails.root.join('lib/faker_randomizer')

FactoryBot.define do
  factory :comment do
    user
    content { FakerRandomizer::ALL.sample(rand(3..20)).join(' ') }
    trait :of_story do
      commentable { create(:story) }
      parent { nil }
    end
    trait :of_comment do
      commentable { create(:comment, :of_story) }
      parent { commentable }
    end
  end
end
