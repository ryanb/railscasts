class AddGithubUidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :github_uid, :string
  end

  def self.down
    remove_column :users, :github_uid
  end
end
