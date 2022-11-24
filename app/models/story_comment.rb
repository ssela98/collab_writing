# frozen_string_literal: true

# == Schema Information
#
# Table name: story_comments
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  comment_id :integer          not null
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StoryComment < ApplicationRecord
  belongs_to :story
  belongs_to :comment

  validate :comment_belongs_to_story
  validates_uniqueness_of :comment_id, scope: :story_id

  before_save :set_sequence

  private

  def comment_belongs_to_story
    errors.add(:comment, 'can\'t be from another story', value: comment_id) if comment && comment.commentable != story
  end

  def set_sequence
    return if self.sequence

    self.sequence = StoryComment.where(story: story)&.maximum(:sequence).to_i + 1
  end
end
