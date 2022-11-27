# frozen_string_literal: true

class AddStoryToComments < ActiveRecord::Migration[7.0]
  def up
    add_reference :comments, :story, null: false, foreign_key: true, if_not_exists: true
    add_index :comments, :story_id, unique: true, if_not_exists: true
  end

  def down
    remove_reference :comments, :story, null: false, foreign_key: true, if_exists: true
    remove_index :comments, :story_id, unique: true, if_exists: true
  end
end
