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

ActiveRecord::Schema.define(version: 20130821041220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                          default: false
    t.string   "wot_name"
    t.integer  "role"
    t.boolean  "clan_war_team",                  default: false
    t.string   "wot_id"
    t.integer  "wins",                 limit: 8
    t.integer  "losses",               limit: 8
    t.integer  "battles_count",        limit: 8
    t.integer  "spotted",              limit: 8
    t.integer  "frags",                limit: 8
    t.integer  "survived",             limit: 8
    t.integer  "experiance",           limit: 8
    t.integer  "max_experiance",       limit: 8
    t.integer  "capture_points",       limit: 8
    t.integer  "defense_points",       limit: 8
    t.integer  "damage_dealt",         limit: 8
    t.integer  "hit_percentage",       limit: 8
    t.string   "clan_id"
    t.string   "clan_name"
    t.string   "clan_abbr"
    t.string   "clan_logo"
    t.float    "avg_tier"
    t.integer  "wins_24hr",            limit: 8
    t.integer  "losses_24hr",          limit: 8
    t.integer  "battles_count_24hr",   limit: 8
    t.integer  "spotted_24hr",         limit: 8
    t.integer  "frags_24hr",           limit: 8
    t.integer  "survived_24hr",        limit: 8
    t.integer  "experiance_24hr",      limit: 8
    t.integer  "capture_points_24hr",  limit: 8
    t.integer  "defense_points_24hr",  limit: 8
    t.integer  "damage_dealt_24hr",    limit: 8
    t.integer  "hit_percentage_24hr",  limit: 8
    t.float    "avg_tier_24hr"
    t.integer  "wins_7day",            limit: 8
    t.integer  "losses_7day",          limit: 8
    t.integer  "battles_count_7day",   limit: 8
    t.integer  "spotted_7day",         limit: 8
    t.integer  "frags_7day",           limit: 8
    t.integer  "survived_7day",        limit: 8
    t.integer  "experiance_7day",      limit: 8
    t.integer  "capture_points_7day",  limit: 8
    t.integer  "defense_points_7day",  limit: 8
    t.integer  "damage_dealt_7day",    limit: 8
    t.integer  "hit_percentage_7day",  limit: 8
    t.float    "avg_tier_7day"
    t.integer  "wins_30day",           limit: 8
    t.integer  "losses_30day",         limit: 8
    t.integer  "battles_count_30day",  limit: 8
    t.integer  "spotted_30day",        limit: 8
    t.integer  "frags_30day",          limit: 8
    t.integer  "survived_30day",       limit: 8
    t.integer  "experiance_30day",     limit: 8
    t.integer  "capture_points_30day", limit: 8
    t.integer  "defense_points_30day", limit: 8
    t.integer  "damage_dealt_30day",   limit: 8
    t.integer  "hit_percentage_30day", limit: 8
    t.float    "avg_tier_30day"
    t.integer  "wins_60day",           limit: 8
    t.integer  "losses_60day",         limit: 8
    t.integer  "battles_count_60day",  limit: 8
    t.integer  "spotted_60day",        limit: 8
    t.integer  "frags_60day",          limit: 8
    t.integer  "survived_60day",       limit: 8
    t.integer  "experiance_60day",     limit: 8
    t.integer  "capture_points_60day", limit: 8
    t.integer  "defense_points_60day", limit: 8
    t.integer  "damage_dealt_60day",   limit: 8
    t.integer  "hit_percentage_60day", limit: 8
    t.float    "avg_tier_60day"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["wot_id"], name: "index_users_on_wot_id", using: :btree

end
