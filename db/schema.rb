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

ActiveRecord::Schema.define(version: 2020_07_31_102639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.integer "member_id"
    t.integer "practice_id"
    t.integer "status"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "executive_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.boolean "admin", default: false
    t.string "nickname"
    t.boolean "receive_email", default: false
    t.integer "position", default: 0
    t.index ["reset_password_token"], name: "index_executive_users_on_reset_password_token", unique: true
  end

  create_table "line_group_for_bots", force: :cascade do |t|
    t.string "group_id"
    t.boolean "send_message", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "line_reply_messages", force: :cascade do |t|
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "nickname"
    t.integer "generation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_kana"
    t.string "last_kana"
    t.string "email"
    t.boolean "leave_on_absence", default: false
  end

  create_table "numbers", force: :cascade do |t|
    t.string "name"
    t.integer "leader_member_id_1"
    t.integer "leader_member_id_2"
    t.integer "leader_member_id_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practices", force: :cascade do |t|
    t.text "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "start_time"
    t.time "end_time"
    t.string "place"
    t.integer "kind", default: 0
    t.boolean "includes_obog", default: false
    t.boolean "final_reminder_aveilable", default: false
    t.string "belonging"
  end

end
