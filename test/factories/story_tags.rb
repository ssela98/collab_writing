# frozen_string_literal: true

# == Schema Information
#
# Table name: story_tags
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'faker'

FactoryBot.define do
  factory :story_tag do
    tag
    story
  end
end
