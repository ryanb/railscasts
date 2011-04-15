class AddAncestryToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :ancestry, :string
    add_index :comments, :ancestry
  end

  def self.down
    remove_column :comments, :ancestry
    remove_index :comments, :ancestry
  end
end
