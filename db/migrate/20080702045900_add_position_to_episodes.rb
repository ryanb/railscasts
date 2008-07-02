class AddPositionToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :position, :integer, :default => 0
    Episode.all.each_with_index { |e, i| e.update_attribute(:position, i+1) }
  end

  def self.down
    remove_column :episodes, :position
  end
end
