# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[7.0]
  def up
    create_table :tags, if_not_exists: true do |t|
      t.string :name, unique: true
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tags, :name, unique: true, if_not_exists: true
    add_index :tags, :story_id, if_not_exists: true
  end

  def down
    drop_table :tags, if_exists: true
  end
end
