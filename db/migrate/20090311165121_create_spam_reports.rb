class CreateSpamReports < ActiveRecord::Migration
  def self.up
    create_table :spam_reports do |t|
      t.integer :comment_id
      t.string :comment_ip
      t.string :comment_site_url
      t.string :comment_name
      t.string :user_ip
      t.datetime :confirmed_at
      t.timestamps
    end
  end

  def self.down
    drop_table :spam_reports
  end
end
