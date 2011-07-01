class RemoveHiddenFromComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, :hidden
  end

  def self.down
    add_column :comments, :hidden, :boolean, :default => false, :null => false
  end
end
