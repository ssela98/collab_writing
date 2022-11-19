# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  content    :text
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require Rails.root.join('lib/faker_randomizer')

FactoryBot.define do
  factory :story do
    user
    title { FakerRandomizer::ALL.sample(rand(3..5)).join(' ') }
    content { FakerRandomizer::ALL.sample(rand(3..20)).join(' ') }
    visible { true }
  end
end
