class AddAsciicastsToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :asciicasts, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :episodes, :asciicasts
  end
end
