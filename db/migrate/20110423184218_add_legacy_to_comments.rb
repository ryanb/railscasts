class AddLegacyToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :legacy, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :comments, :legacy
  end
end
