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

ActiveRecord::Schema.define(version: 20171019170537) do

  create_table "channels", force: :cascade do |t|
    t.text     "last_body"
    t.datetime "last_called"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "channel_id"
    t.string   "path"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "cronofy_account_id"
    t.string   "cronofy_access_token"
    t.string   "cronofy_refresh_token"
    t.date     "cronofy_access_token_expiration"
    t.string   "cronofy_domain"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "smart_invites", force: :cascade do |t|
    t.string   "smart_invite_id"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "cronofy_id"
    t.string   "email"
    t.string   "name"
    t.string   "timezone"
    t.string   "cronofy_access_token"
    t.string   "cronofy_refresh_token"
    t.date     "cronofy_access_token_expiration"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "cronofy_is_service_account_token"
    t.string   "cronofy_service_account_error_key"
    t.string   "cronofy_service_account_error_description"
    t.string   "cronofy_service_account_owner"
  end

end
