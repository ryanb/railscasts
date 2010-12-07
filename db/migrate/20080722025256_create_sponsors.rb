class CreateSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsors do |t|
      t.string :name
      t.boolean :active, :default => false, :null => false
      t.string :site_url
      t.string :image_url
      t.timestamps
    end
  end

  def self.down
    drop_table :sponsors
  end
end
