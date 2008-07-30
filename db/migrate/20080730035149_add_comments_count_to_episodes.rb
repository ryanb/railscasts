class AddCommentsCountToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :comments_count, :integer, :default => 0, :null => false
    execute "UPDATE episodes SET comments_count=(SELECT COUNT(*) FROM comments WHERE episode_id=episodes.id)"
  end

  def self.down
    remove_column :episodes, :comments_count
  end
end
