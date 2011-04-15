class AddHiddenToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :hidden, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :comments, :hidden
  end
end
