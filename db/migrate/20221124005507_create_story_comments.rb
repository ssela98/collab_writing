# frozen_string_literal: true

class CreateStoryComments < ActiveRecord::Migration[7.0]
  def up
    create_table :story_comments, if_not_exists: true do |t|
      t.references :story, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.integer :sequence

      t.timestamps
    end

    add_index :story_comments, %i[story_id comment_id], unique: true, if_not_exists: true
  end

  def down
    drop_table :story_comments, if_exists: true
    remove_index :story_comments, %i[story_id comment_id], if_exists: true
  end
end
