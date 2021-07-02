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

ActiveRecord::Schema.define(version: 2021_07_02_045635) do

  create_table "bookings", force: :cascade do |t|
    t.integer "timeslot_id", null: false
    t.integer "user_id", null: false
    t.integer "state", default: 0, null: false
    t.json "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state"], name: "index_bookings_on_state"
    t.index ["timeslot_id"], name: "index_bookings_on_timeslot_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "facility_bases", force: :cascade do |t|
    t.string "name", null: false
    t.string "type", null: false
    t.json "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type"], name: "index_facility_bases_on_type"
  end

  create_table "timeslots", force: :cascade do |t|
    t.datetime "slot_time", null: false
    t.integer "facility_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "state", default: 0
    t.index ["facility_id", "slot_time"], name: "index_timeslot_facility_slot_time", unique: true
    t.index ["state"], name: "index_timeslots_on_state"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "api_token", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["api_token"], name: "index_users_on_api_token"
  end

end
