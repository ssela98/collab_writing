# frozen_string_literal: true

class AddRootCommentToComments < ActiveRecord::Migration[7.0]
  def up
    add_reference :comments, :root_comment, foreign_key: { to_table: :comments }, if_not_exists: true
  end

  def down
    remove_reference :comments, :root_comment, if_exists: true
  end
end
