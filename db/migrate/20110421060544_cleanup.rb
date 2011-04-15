class Cleanup < ActiveRecord::Migration
  def self.up
    drop_table :downloads
    drop_table :spam_questions
    drop_table :spam_checks
    drop_table :spam_reports
    drop_table :sponsors
    remove_column :feedback_messages, :concerning
  end

  def self.down
    create_table "downloads" do |t|
      t.integer  "episode_id"
      t.string   "url"
      t.string   "format"
      t.integer  "bytes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "downloads", ["episode_id"], :name => "index_downloads_on_episode_id"

    add_column :feedback_messages, :concerning, :string

    create_table "spam_checks" do |t|
      t.string   "regexp"
      t.integer  "weight"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "spam_questions" do |t|
      t.string   "question"
      t.string   "answer"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "spam_reports" do |t|
      t.integer  "comment_id"
      t.string   "comment_ip"
      t.string   "comment_site_url"
      t.string   "comment_name"
      t.datetime "confirmed_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "hit_count"
    end

    create_table "sponsors" do |t|
      t.string   "name"
      t.boolean  "active",     :default => false, :null => false
      t.string   "site_url"
      t.string   "image_url"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "force_top",  :default => false, :null => false
    end
  end
end
