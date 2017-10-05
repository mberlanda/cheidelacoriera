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

ActiveRecord::Schema.define(version: 20171004061308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.date     "date"
    t.time     "time"
    t.string   "season"
    t.string   "score"
    t.text     "notes"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "competition_id"
    t.index ["away_team_id"], name: "index_events_on_away_team_id", using: :btree
    t.index ["competition_id"], name: "index_events_on_competition_id", using: :btree
    t.index ["home_team_id"], name: "index_events_on_home_team_id", using: :btree
  end

  create_table "fans", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "place_of_birth"
    t.string   "fidelity_card_no"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_fans_on_user_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.string   "url"
    t.string   "image_url"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "transport_means", force: :cascade do |t|
    t.string   "kind"
    t.string   "company"
    t.string   "phone_number"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer  "total_seats"
    t.integer  "available_seats"
    t.integer  "requested_seats"
    t.integer  "reserved_seats"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "event_id"
    t.integer  "transport_mean_id"
    t.index ["event_id"], name: "index_trips_on_event_id", using: :btree
    t.index ["transport_mean_id"], name: "index_trips_on_transport_mean_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "role",                   default: "fan"
    t.string   "status",                 default: "pending"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "events", "competitions"
  add_foreign_key "events", "teams", column: "away_team_id"
  add_foreign_key "events", "teams", column: "home_team_id"
  add_foreign_key "fans", "users"
  add_foreign_key "trips", "events"
  add_foreign_key "trips", "transport_means"
end
