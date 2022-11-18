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
require 'faker'

FactoryBot.define do
  factory :story do
    user
    title { Faker::Movies::HitchhikersGuideToTheGalaxy.quote }
    content { Faker::TvShows::BrooklynNineNine.quote }
    visible { true }
  end
end
