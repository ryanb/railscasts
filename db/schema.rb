# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080721011326) do

  create_table "comments", :force => true do |t|
    t.integer  "episode_id"
    t.text     "content"
    t.string   "name"
    t.string   "email"
    t.string   "site_url"
    t.string   "user_ip"
    t.string   "user_agent"
    t.string   "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", :force => true do |t|
    t.integer  "episode_id"
    t.string   "url"
    t.string   "format"
    t.integer  "bytes"
    t.integer  "seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "description"
    t.text     "notes"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",     :default => 0
  end

  create_table "taggings", :force => true do |t|
    t.integer  "episode_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
