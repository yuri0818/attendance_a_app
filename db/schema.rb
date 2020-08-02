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

ActiveRecord::Schema.define(version: 20200625044955) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.boolean "tomorrow"
    t.boolean "change_tomorrow"
    t.datetime "scheduled_end_time"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.string "business_content"
    t.string "instructor_mark"
    t.string "overtime_change"
    t.string "change"
    t.string "one_month_change"
    t.string "overtime_status"
    t.string "edit_status"
    t.string "month_status"
    t.string "overtime_authorizer"
    t.string "edit_authorizer"
    t.string "month_authorizer"
    t.date "apporoval_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "office_number"
    t.string "office_name"
    t.string "office_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "affiliation"
    t.string "employee_number"
    t.string "uid"
    t.time "basic_work_time", default: "2000-01-01 23:00:00"
    t.time "designation_started_at", default: "2000-01-01 00:00:00"
    t.time "designation_finished_at", default: "2000-01-01 09:00:00"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
