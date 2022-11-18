# frozen_string_literal: true

class CreateStories < ActiveRecord::Migration[7.0]
  def up
    create_table :stories, if_not_exists: true do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :content
      t.boolean :public, default: true

      t.timestamps
    end

    add_index :stories, :user_id, if_not_exists: true
    add_index :stories, :public, if_not_exists: true
  end

  def down
    drop_table :stories, if_exists: true
    remove_index :stories, :user_id, if_exists: true
    remove_index :stories, :public, if_exists: true
  end
end
