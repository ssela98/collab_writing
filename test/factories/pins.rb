# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  comment_id :integer          not null
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :pin do
    comment
    story { comment.story }
  end
end
