class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.belongs_to :episode
      t.text :content
      t.string :name
      t.string :email
      t.string :site_url
      t.string :user_ip
      t.string :user_agent
      t.string :referrer
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
