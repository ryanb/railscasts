class CreateSpamQuestions < ActiveRecord::Migration
  def self.up
    create_table :spam_questions do |t|
      t.string :question
      t.string :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :spam_questions
  end
end
