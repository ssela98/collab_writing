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
class Pin < ApplicationRecord
  belongs_to :story
  belongs_to :comment

  validate :comment_belongs_to_story
  validates :comment_id, uniqueness: { scope: :story_id }

  before_save :set_sequence

  private

  def comment_belongs_to_story
    errors.add(:comment, 'can\'t be from another story', value: comment_id) if comment && comment.story != story
  end

  def set_sequence
    return if sequence

    self.sequence = Pin.where(story:)&.maximum(:sequence).to_i + 1
  end
end
