# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  parent_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  root_comment_id :integer
#  level           :integer          default(0)
#  story_id        :integer          not null
#
require Rails.root.join('lib/faker_randomizer')

FactoryBot.define do
  factory :comment do
    user
    story
    content { FakerRandomizer::ALL.sample(rand(3..20)).join(' ') }
  end
end
