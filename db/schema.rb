# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140314183340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "deck"
    t.boolean  "public",     default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["user_id", "start_time"], name: "index_events_on_user_id_and_start_time", using: :btree

  create_table "title_appointments", force: true do |t|
    t.integer  "user_id"
    t.integer  "title_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "title_appointments", ["title_id"], name: "index_title_appointments_on_title_id", using: :btree
  add_index "title_appointments", ["user_id", "title_id"], name: "index_title_appointments_on_user_id_and_title_id", unique: true, using: :btree
  add_index "title_appointments", ["user_id"], name: "index_title_appointments_on_user_id", using: :btree

  create_table "titles", force: true do |t|
    t.string   "name"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "titles", ["name"], name: "index_titles_on_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.integer  "rank",            default: 0
    t.string   "time_zone",       default: "Pacific Time (US & Canada)"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
