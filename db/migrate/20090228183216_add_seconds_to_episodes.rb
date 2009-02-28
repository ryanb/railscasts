class AddSecondsToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :seconds, :integer
    Episode.reset_column_information
    Episode.all(:include => :downloads).each do |episode|
      # there are more efficient ways to do this, but it is just a one time deal so it's okay.
      episode.update_attribute(:seconds, episode.downloads.first.seconds)
    end
  end

  def self.down
    remove_column :episodes, :seconds
  end
end
