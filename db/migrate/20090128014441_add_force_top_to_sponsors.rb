class AddForceTopToSponsors < ActiveRecord::Migration
  def self.up
    add_column :sponsors, :force_top, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :sponsors, :force_top
  end
end
