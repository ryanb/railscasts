class AddEmailOnReplyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email_on_reply, :boolean, :default => false, :null => false
    add_column :users, :unsubscribe_token, :string
  end

  def self.down
    remove_column :users, :unsubscribe_token
    remove_column :users, :email_on_reply
  end
end
