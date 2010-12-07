class CreateSpamChecks < ActiveRecord::Migration
  def self.up
    create_table :spam_checks do |t|
      t.string :regexp
      t.integer :weight
      t.timestamps
    end
  end

  def self.down
    drop_table :spam_checks
  end
end
