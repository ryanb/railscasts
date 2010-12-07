class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.integer :episode_id
      t.string :url
      t.string :format
      t.integer :bytes
      t.integer :seconds
      t.timestamps
    end
  end

  def self.down
    drop_table :downloads
  end
end
