class AddHitCountToSpamReports < ActiveRecord::Migration
  def self.up
    add_column :spam_reports, :hit_count, :integer
  end

  def self.down
    remove_column :spam_reports, :hit_count
  end
end
