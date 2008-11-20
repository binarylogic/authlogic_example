class AddUsersOpenidField < ActiveRecord::Migration
  def self.up
    add_column :users, :openid_identifier, :string
    add_index :users, :openid_identifier
    
    change_column :users, :login, :string, :default => nil, :null => true
    change_column :users, :crypted_password, :string, :default => nil, :null => true
    change_column :users, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    remove_column :users, :openid_identifier
    change_column :users, :login, :string, :default => "", :null => false
    change_column :users, :crypted_password, :string, :default => "", :null => false
    change_column :users, :password_salt, :string, :default => "", :null => false
  end
end
