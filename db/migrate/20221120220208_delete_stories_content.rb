# frozen_string_literal: true

class DeleteStoriesContent < ActiveRecord::Migration[7.0]
  def up
    remove_column :stories, :content, if_exists: true
  end

  def down
    add_column :stories, :content, :text, if_not_exists: true
  end
end
