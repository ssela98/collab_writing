# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                             :integer          not null, primary key
#  user_id                        :integer          not null
#  parent_id                      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  root_comment_id                :integer
#  level                          :integer          default(0)
#  story_id                       :integer          not null
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#
require Rails.root.join('lib/faker_randomizer')

FactoryBot.define do
  factory :comment do
    user
    story
    content { FakerRandomizer::ALL.sample(rand(3..20)).join(' ') }
  end
end
