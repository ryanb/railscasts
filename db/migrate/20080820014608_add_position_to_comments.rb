class AddPositionToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :position, :integer

    # terribly inefficient, but it gets the job done.
    Episode.all.each do |episode|
      episode.comments.each_with_index do |comment, index|
        comment.update_attribute :position, index+1
      end
    end
  end

  def self.down
    remove_column :comments, :position
  end
end
