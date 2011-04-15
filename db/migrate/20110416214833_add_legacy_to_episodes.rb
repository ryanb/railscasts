class AddLegacyToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :legacy, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :episodes, :legacy
  end
end
