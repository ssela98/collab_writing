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
class Comment < ApplicationRecord
  include Votable

  belongs_to :user
  belongs_to :story, inverse_of: :comments
  belongs_to :parent, optional: true, class_name: 'Comment', inverse_of: :comments
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent
  has_one :pin, class_name: 'Pin', dependent: :destroy

  # TODO: extract this and story.rb's part in a concern
  has_rich_text :content
  scope :joins_content, lambda {
                          joins("INNER JOIN action_text_rich_texts
                                        ON action_text_rich_texts.record_id = comments.id
                                        AND action_text_rich_texts.record_type = 'Comment'")
                        }
  scope :where_content, lambda { |content|
    return joins_content.where(action_text_rich_texts: { body: nil }) unless content

    joins_content.where('action_text_rich_texts.body LIKE ?', "%#{content}%")
  }

  validates :content, presence: true

  after_create :set_level
  after_create :set_root_comment_id

  private

  def set_level
    return if level.to_i >= parent&.level.to_i + 1

    update(level: parent_id ? parent&.level.to_i + 1 : 0)
  end

  def set_root_comment_id
    update(root_comment_id: (level&.to_i % 10).zero? ? id : parent.root_comment_id)
  end
end
