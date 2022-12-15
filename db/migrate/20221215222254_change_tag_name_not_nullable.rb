# frozen_string_literal: true

class ChangeTagNameNotNullable < ActiveRecord::Migration[7.0]
  def up
    change_column :tags, :name, :string, unique: true, limit: 24, null: false, if_exists: true
  end

  def down
    change_column :tags, :name, :string, unique: true, limit: 24, null: true, if_exists: true
  end
end
