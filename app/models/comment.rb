# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  commentable_type :string           not null
#  commentable_id   :integer          not null
#  parent_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  level            :integer          default(1)
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: 'Comment', inverse_of: :comments
  has_one :pin, class_name: 'Pin', dependent: :destroy
  has_many :comments, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

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

  after_create_commit do
    broadcast_prepend_later_to [commentable, :comments], target: "#{dom_id(parent || commentable)}_comments", partial: 'comments/comment_with_replies'
  end

  after_update_commit do
    broadcast_replace_later_to self
  end

  after_destroy_commit do
    broadcast_remove_to self
    broadcast_action_to self, action: :remove, target: "#{dom_id(self)}_with_comments"
  end

  private

  def set_level
    return if self.level.to_i >= self.parent&.level.to_i + 1

    self.update(level: self.parent_id ? self.parent&.level.to_i + 1 : 0)
  end

  def set_root_comment_id
    self.update(root_comment_id: self.level&.to_i % 10 == 0 ? self.id : self.parent.root_comment_id)
  end
end
