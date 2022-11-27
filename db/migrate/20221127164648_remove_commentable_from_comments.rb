# frozen_string_literal: true

class RemoveCommentableFromComments < ActiveRecord::Migration[7.0]
  def up
    remove_reference :comments, :commentable, polymorphic: true, null: false, if_exists: true
  end

  def down
    add_reference :comments, :commentable, polymorphic: true, null: false, if_not_exists: true
  end
end
