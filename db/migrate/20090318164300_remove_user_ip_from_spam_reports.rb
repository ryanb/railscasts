class RemoveUserIpFromSpamReports < ActiveRecord::Migration
  def self.up
    remove_column :spam_reports, :user_ip
  end

  def self.down
    add_column :spam_reports, :user_ip, :string
  end
end
