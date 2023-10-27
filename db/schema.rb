# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_27_113712) do
  create_table "channels", force: :cascade do |t|
    t.text "last_body"
    t.datetime "last_called", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "channel_id"
    t.string "path"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "cronofy_account_id"
    t.string "cronofy_access_token"
    t.string "cronofy_refresh_token"
    t.date "cronofy_access_token_expiration"
    t.string "cronofy_domain"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "smart_invites", force: :cascade do |t|
    t.string "smart_invite_id"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "cronofy_id"
    t.string "email"
    t.string "name"
    t.string "timezone"
    t.string "cronofy_access_token"
    t.string "cronofy_refresh_token"
    t.date "cronofy_access_token_expiration"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "cronofy_is_service_account_token"
    t.string "cronofy_service_account_error_key"
    t.string "cronofy_service_account_error_description"
    t.string "cronofy_service_account_owner"
  end

end
