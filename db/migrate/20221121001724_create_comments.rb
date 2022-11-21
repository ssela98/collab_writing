class CreateComments < ActiveRecord::Migration[7.0]
  def up
    create_table :comments, if_not_exists: true do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :commentable, polymorphic: true, null: false
      t.integer :parent_id

      t.timestamps
    end

    add_index :comments, :user_id, if_not_exists: true
  end

  def down
    drop_table :comments, if_exists: true
    remove_index :comments, :user_id, if_exists: true
  end
end
