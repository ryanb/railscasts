class AddFileSizesToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :file_sizes, :text
  end

  def self.down
    remove_column :episodes, :file_sizes
  end
end
