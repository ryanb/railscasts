class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :name
      t.string :permalink
      t.text :description
      t.text :notes
      t.datetime :published_at
      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
