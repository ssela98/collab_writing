# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_type :string           not null
#  commentable_id   :integer          not null
#  parent_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  level            :integer          default(1)
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
