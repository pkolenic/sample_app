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

ActiveRecord::Schema.define(version: 20140428004459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "event_start"
    t.datetime "event_end"
    t.integer  "event_type"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forem_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "forem_categories", ["slug"], name: "index_forem_categories_on_slug", unique: true, using: :btree

  create_table "forem_forums", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", default: 0
    t.string  "slug"
  end

  add_index "forem_forums", ["slug"], name: "index_forem_forums_on_slug", unique: true, using: :btree

  create_table "forem_groups", force: true do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], name: "index_forem_groups_on_name", using: :btree

  create_table "forem_memberships", force: true do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], name: "index_forem_memberships_on_group_id", using: :btree

  create_table "forem_moderator_groups", force: true do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], name: "index_forem_moderator_groups_on_forum_id", using: :btree

  create_table "forem_posts", force: true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_to_id"
    t.string   "state",       default: "pending_review"
    t.boolean  "notified",    default: false
  end

  add_index "forem_posts", ["reply_to_id"], name: "index_forem_posts_on_reply_to_id", using: :btree
  add_index "forem_posts", ["state"], name: "index_forem_posts_on_state", using: :btree
  add_index "forem_posts", ["topic_id"], name: "index_forem_posts_on_topic_id", using: :btree
  add_index "forem_posts", ["user_id"], name: "index_forem_posts_on_user_id", using: :btree

  create_table "forem_subscriptions", force: true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", force: true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "locked",       default: false,            null: false
    t.boolean  "pinned",       default: false
    t.boolean  "hidden",       default: false
    t.datetime "last_post_at"
    t.string   "state",        default: "pending_review"
    t.integer  "views_count",  default: 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], name: "index_forem_topics_on_forum_id", using: :btree
  add_index "forem_topics", ["slug"], name: "index_forem_topics_on_slug", unique: true, using: :btree
  add_index "forem_topics", ["state"], name: "index_forem_topics_on_state", using: :btree
  add_index "forem_topics", ["user_id"], name: "index_forem_topics_on_user_id", using: :btree

  create_table "forem_views", force: true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             default: 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], name: "index_forem_views_on_updated_at", using: :btree
  add_index "forem_views", ["user_id"], name: "index_forem_views_on_user_id", using: :btree
  add_index "forem_views", ["viewable_id"], name: "index_forem_views_on_viewable_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "microposts", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "status",                   default: 0
    t.string   "wot_tournament_link"
    t.string   "wot_team_link"
    t.string   "team_name"
    t.text     "description"
    t.string   "password"
    t.integer  "minimum_team_size"
    t.integer  "maximum_team_size"
    t.integer  "heavy_tier_limit"
    t.integer  "medium_tier_limit"
    t.integer  "td_tier_limit"
    t.integer  "light_tier_limit"
    t.string   "spg_tier_limit"
    t.integer  "team_maximum_tier_points"
    t.text     "victory_conditions"
    t.text     "schedule"
    t.text     "prizes"
    t.text     "maps"
    t.string   "team"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tournaments", ["end_date"], name: "index_tournaments_on_end_date", using: :btree

  create_table "updates", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                          default: false
    t.string   "wot_name"
    t.integer  "role",                           default: 0
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
    t.string   "reset_token"
    t.datetime "reset_expire"
    t.boolean  "active",                         default: false
    t.string   "time_zone",                      default: "Pacific Time (US & Canada)"
    t.datetime "last_online"
    t.boolean  "forem_admin",                    default: false
    t.string   "forem_state",                    default: "pending_review"
    t.boolean  "forem_auto_subscribe",           default: false
    t.string   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["reset_token"], name: "index_users_on_reset_token", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["wot_id"], name: "index_users_on_wot_id", using: :btree

end
