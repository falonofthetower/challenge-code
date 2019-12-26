# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_22_194814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "tags", array: true
    t.integer "ratings", array: true
    t.index ["ratings"], name: "index_books_on_ratings", using: :gin
    t.index ["tags"], name: "index_books_on_tags", using: :gin
  end

  create_table "events", force: :cascade do |t|
    t.text "payload"
    t.bigint "match_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "checked", default: false
    t.jsonb "json_payload", default: {}, null: false
    t.index ["json_payload"], name: "index_events_on_json_payload", using: :gin
    t.index ["match_id"], name: "index_events_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "plan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "match_string"
    t.index ["plan_id"], name: "index_matches_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
