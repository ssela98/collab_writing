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
#
class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  include RecordHelper

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_rich_text :content

  validates :content, presence: true, no_attachments: true

  after_create_commit lambda {
    broadcast_append_to [commentable, :comments],
                        target: "#{dom_id(commentable)}_comments",
                        partial: 'comments/comment',
                        locals: { commentable: }
  }

  after_update_commit lambda {
    broadcast_replace_to self, target: dom_id_for_records(commentable, self), partial: 'comments/comment', locals: { commentable: }
  }

  after_destroy_commit lambda {
    broadcast_remove_to self, target: dom_id_for_records(commentable, self)
  }
end
