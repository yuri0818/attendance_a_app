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
    t.datetime "scheduled_end_time"
    t.datetime "designation_started_at"
    t.datetime "designation_finished_at"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.datetime "change_started_at"
    t.datetime "change_finished_at"
    t.string "instructor"
    t.string "authorizer"
    t.string "business_content"
    t.string "instructo_mark"
    t.string "overtime_app"
    t.string "overtime_app_approval"
    t.string "overtime_edit_app"
    t.string "overtime_edit_approval"
    t.string "month_app"
    t.string "month_app_app"
    t.string "overtime_app_authorizer"
    t.string "overtime_edit_app_authorizer"
    t.string "month_app_app_authorizer"
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
    t.string "employee_number"
    t.string "uid"
    t.time "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2020-06-29 23:00:00"
    t.datetime "work_time", default: "2020-06-29 22:30:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
