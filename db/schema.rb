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

ActiveRecord::Schema[7.0].define(version: 2023_01_18_183849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "request_id", null: false
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.index ["request_id"], name: "index_bills_on_request_id"
    t.index ["room_id"], name: "index_bills_on_room_id"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "places_amount", null: false
    t.integer "room_class", default: 0, null: false
    t.datetime "stay_time_from", null: false
    t.datetime "stay_time_to", null: false
    t.text "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "places_amount", default: 1, null: false
    t.integer "room_class", default: 0, null: false
    t.integer "room_number"
    t.boolean "is_free", default: true, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price"], name: "index_rooms_on_price"
    t.index ["room_number"], name: "index_rooms_on_room_number", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "bills", "requests"
  add_foreign_key "bills", "rooms"
  add_foreign_key "bills", "users"
  add_foreign_key "requests", "users"
end
