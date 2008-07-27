class AddForeignKeyIndexes < ActiveRecord::Migration
  def self.up
    add_index :comments, :episode_id
    add_index :downloads, :episode_id
    add_index :taggings, :episode_id
    add_index :taggings, :tag_id
  end

  def self.down
    remove_index :comments, :episode_id
    remove_index :downloads, :episode_id
    remove_index :taggings, :episode_id
    remove_index :taggings, :tag_id
  end
end
