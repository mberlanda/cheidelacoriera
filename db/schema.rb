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

ActiveRecord::Schema.define(version: 20171218103411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.index ["event_id"], name: "index_albums_on_event_id"
  end

  create_table "competitions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.date "date"
    t.time "time"
    t.string "season"
    t.string "score"
    t.text "notes"
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "competition_id"
    t.string "venue"
    t.string "poster_url"
    t.date "bookable_from"
    t.date "bookable_until"
    t.integer "requested_seats", default: 0
    t.integer "confirmed_seats", default: 0
    t.string "custom_name"
    t.string "slug"
    t.string "audience", default: "everyone"
    t.integer "pax", default: 10
    t.integer "rejected_seats", default: 0
    t.string "transport_mean"
    t.integer "available_seats", default: 0
    t.integer "total_seats", default: 0
    t.index ["away_team_id"], name: "index_events_on_away_team_id"
    t.index ["competition_id"], name: "index_events_on_competition_id"
    t.index ["home_team_id"], name: "index_events_on_home_team_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "image_url"
    t.text "content"
    t.date "date"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", id: :serial, force: :cascade do |t|
    t.integer "total_seats"
    t.string "fan_names", default: [], array: true
    t.text "notes"
    t.string "status"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "event_id"
    t.date "mail_sent"
    t.index ["event_id"], name: "index_reservations_on_event_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "url"
    t.string "image_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transport_means", id: :serial, force: :cascade do |t|
    t.string "kind"
    t.string "company"
    t.string "phone_number"
    t.string "email"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "role", default: "fan"
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "place_of_birth"
    t.string "phone_number"
    t.boolean "newsletter", default: true
    t.date "activation_date"
    t.boolean "mailing_listed", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "albums", "events"
  add_foreign_key "events", "competitions"
  add_foreign_key "events", "teams", column: "away_team_id"
  add_foreign_key "events", "teams", column: "home_team_id"
  add_foreign_key "reservations", "events"
  add_foreign_key "reservations", "users"
end
