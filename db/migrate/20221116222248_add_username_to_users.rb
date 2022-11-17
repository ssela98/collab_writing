class AddUsernameToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :username, :string, null: false, if_not_exists: true
    add_index :users, :username, unique: true, if_not_exists: true
  end

  def down
    remove_column :users, :username, if_exists: true
    remove_index :users, :username, if_exists: true
  end
end
