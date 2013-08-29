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

ActiveRecord::Schema.define(version: 20130829184219) do

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handle"
  end

  create_table "comments", force: true do |t|
    t.integer "commentable_type", null: false
    t.integer "commentable_id",   null: false
    t.integer "parent_id"
    t.integer "user_id"
    t.text    "content",          null: false
    t.integer "created_at",       null: false
  end

  add_index "comments", ["commentable_id"], name: "item_id", using: :btree
  add_index "comments", ["commentable_type", "commentable_id"], name: "object_type", using: :btree
  add_index "comments", ["created_at"], name: "created_at", using: :btree
  add_index "comments", ["parent_id"], name: "parent_id", using: :btree
  add_index "comments", ["parent_id"], name: "parent_id_2", using: :btree
  add_index "comments", ["user_id"], name: "user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer "user_id",   null: false
    t.integer "source_id", null: false
  end

  add_index "favorites", ["source_id"], name: "source_id", using: :btree
  add_index "favorites", ["user_id", "source_id"], name: "user_id", using: :btree

  create_table "languages", force: true do |t|
    t.string  "title",                     null: false
    t.string  "name",                      null: false
    t.string  "syntax",                    null: false
    t.integer "sources_count", default: 0
  end

  add_index "languages", ["name"], name: "name", using: :btree

  create_table "links", force: true do |t|
    t.integer "source_id", null: false
    t.integer "tag_id",    null: false
    t.float   "weight",    null: false
  end

  add_index "links", ["source_id", "tag_id"], name: "source_id", using: :btree
  add_index "links", ["tag_id"], name: "entity_value_id", using: :btree

  create_table "pages", force: true do |t|
    t.string "title",                    null: false
    t.string "name",                     null: false
    t.text   "text",  limit: 2147483647, null: false
  end

  add_index "pages", ["name"], name: "name", using: :btree

  create_table "profiles", force: true do |t|
    t.integer "user_id",                                 null: false
    t.integer "dd"
    t.integer "mm"
    t.integer "yy"
    t.integer "newsletter", limit: 1,        default: 1, null: false
    t.text    "aboutme",    limit: 16777215
    t.string  "website"
    t.string  "gplus"
    t.integer "avatar",     limit: 1,        default: 0, null: false
  end

  add_index "profiles", ["user_id"], name: "user_id", using: :btree

  create_table "rating_votes", force: true do |t|
    t.integer "rating_id",            null: false
    t.integer "user_id"
    t.string  "user_ip",   limit: 15
    t.float   "value",                null: false
    t.integer "timestamp",            null: false
  end

  add_index "rating_votes", ["rating_id"], name: "rating_id", using: :btree
  add_index "rating_votes", ["timestamp"], name: "timestamp", using: :btree
  add_index "rating_votes", ["user_id"], name: "user_id", using: :btree
  add_index "rating_votes", ["user_ip"], name: "user_ip", using: :btree

  create_table "ratings", force: true do |t|
    t.integer "object_type", limit: 1, null: false
    t.integer "object_id",             null: false
    t.integer "type",        limit: 1, null: false
    t.integer "visibility",  limit: 1
    t.string  "data"
    t.integer "votes"
    t.float   "average"
    t.integer "created_at",            null: false
  end

  add_index "ratings", ["average"], name: "average", using: :btree
  add_index "ratings", ["created_at"], name: "created_at", using: :btree
  add_index "ratings", ["object_id"], name: "object_id", using: :btree
  add_index "ratings", ["object_type", "object_id"], name: "object_type_2", using: :btree
  add_index "ratings", ["object_type"], name: "object_type", using: :btree
  add_index "ratings", ["visibility"], name: "visibility", using: :btree
  add_index "ratings", ["votes"], name: "votes", using: :btree

  create_table "social_cron", force: true do |t|
    t.integer "last_posted_source_id", null: false
    t.integer "last_run",              null: false
    t.integer "last_random_run",       null: false
  end

  add_index "social_cron", ["last_posted_source_id"], name: "last_posted_source_id", using: :btree

  create_table "sources", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.integer "private",     limit: 1,          default: 0, null: false
    t.string  "name",                                       null: false
    t.string  "title",                                      null: false
    t.text    "description"
    t.integer "created_at",                                 null: false
    t.text    "text",        limit: 2147483647,             null: false
    t.integer "views",                          default: 0
  end

  add_index "sources", ["description"], name: "search_index_2", type: :fulltext
  add_index "sources", ["language_id"], name: "language_id", using: :btree
  add_index "sources", ["language_id"], name: "type_id", using: :btree
  add_index "sources", ["name"], name: "name", using: :btree
  add_index "sources", ["private"], name: "private", using: :btree
  add_index "sources", ["title"], name: "search_index_1", type: :fulltext
  add_index "sources", ["user_id"], name: "author_id", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name",                      null: false
    t.text    "value",                     null: false
    t.integer "sources_count", default: 0
  end

  add_index "tags", ["name"], name: "name", using: :btree

  create_table "users", force: true do |t|
    t.string  "username",                             null: false
    t.string  "email",                                null: false
    t.string  "password_hash", limit: 32,             null: false
    t.string  "salt",          limit: 10,             null: false
    t.integer "last_login",               default: 0
    t.string  "last_login_ip", limit: 15
    t.integer "level",                                null: false
    t.integer "status",                               null: false
    t.integer "created_at",                           null: false
    t.integer "updated_at"
    t.integer "last_seen_at"
  end

  add_index "users", ["created_at"], name: "created_at", using: :btree
  add_index "users", ["email"], name: "email", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["last_login"], name: "last_login", using: :btree
  add_index "users", ["last_seen_at"], name: "last_seen_at", using: :btree
  add_index "users", ["level"], name: "level", using: :btree
  add_index "users", ["password_hash"], name: "hash", using: :btree
  add_index "users", ["status"], name: "status", using: :btree
  add_index "users", ["username", "email"], name: "username", unique: true, using: :btree

end
