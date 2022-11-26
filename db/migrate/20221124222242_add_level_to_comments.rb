# frozen_string_literal: true

class AddLevelToComments < ActiveRecord::Migration[7.0]
  def up
    add_column :comments, :level, :integer, default: 0, if_not_exists: true
  end

  def down
    remove_column :comments, :level, if_exists: true
  end
end
