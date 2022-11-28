# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id                             :integer          not null, primary key
#  user_id                        :integer          not null
#  title                          :string           not null
#  visible                        :boolean          default(TRUE)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#
class Story < ApplicationRecord
  include Votable

  belongs_to :user

  has_rich_text :content
  has_many :comments, dependent: :destroy, inverse_of: :story
  has_many :pins, dependent: :destroy, inverse_of: :story

  validates :title, presence: true
  validates :content, no_attachments: true
end
