class AddBannedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :banned_at, :datetime
  end

  def self.down
    remove_column :users, :banned_at
  end
end
