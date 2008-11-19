class AddUsersPasswordResetFields < ActiveRecord::Migration
  def self.up
    add_column :users, :perishable_token, :string, :default => "", :null => false
    add_column :users, :email, :string, :default => "", :null => false
    
    add_index :users, :perishable_token
    add_index :users, :email
  end

  def self.down
    remove_column :users, :perishable_token
    remove_column :users, :email
  end
end
