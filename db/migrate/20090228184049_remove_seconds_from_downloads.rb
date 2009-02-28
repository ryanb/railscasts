class RemoveSecondsFromDownloads < ActiveRecord::Migration
  def self.up
    remove_column :downloads, :seconds
  end

  def self.down
    add_column :downloads, :seconds, :integer
  end
end
