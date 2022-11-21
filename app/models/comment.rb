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
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_rich_text :content

  validates :content, presence: true, no_attachments: true

  after_create_commit -> {
    broadcast_append_to [commentable, :comments],
    target: "#{dom_id(commentable)}_comments",
    locals: { commentable: commentable }
  }
end
