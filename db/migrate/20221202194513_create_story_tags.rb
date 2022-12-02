# frozen_string_literal: true

class CreateStoryTags < ActiveRecord::Migration[7.0]
  def up
    create_table :story_tags, if_not_exists: true do |t|
      t.belongs_to :story, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :story_tags, %i[story_id tag_id], unique: true, if_not_exists: true
  end

  def down
    drop_table :story_tags
  end
end
