class CreateFeedbackMessages < ActiveRecord::Migration
  def self.up
    create_table :feedback_messages do |t|
      t.string :name
      t.string :email
      t.string :concerning
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :feedback_messages
  end
end
