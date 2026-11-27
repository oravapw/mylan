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

ActiveRecord::Schema[8.1].define(version: 2026_11_25_072324) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "players", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "vekn", limit: 7
    t.string "country", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["email"], name: "index_players_on_email", unique: true
    t.index ["vekn"], name: "index_players_on_vekn", unique: true
  end

  create_table "tournament_players", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "vekn", limit: 7
    t.bigint "player_id", null: false
    t.bigint "tournament_id", null: false
    t.boolean "confirmed", default: false, null: false
    t.string "email"
    t.text "decklist"
    t.string "token"
    t.index ["player_id"], name: "fk_rails_c9135d9048"
    t.index ["token"], name: "index_tournament_players_on_token", unique: true
    t.index ["tournament_id", "player_id"], name: "index_tournament_players_on_tournament_id_and_player_id", unique: true
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "location", limit: 80
    t.string "organizers", limit: 120
    t.datetime "date"
    t.boolean "decklists", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "prereg", default: false, null: false
    t.string "prereg_slug"
    t.text "prereg_info"
    t.datetime "prereg_end"
    t.boolean "proxies", default: false, null: false
    t.integer "decklist_delay", default: 0, null: false
    t.index ["name"], name: "index_tournaments_on_name", unique: true
    t.index ["prereg_slug"], name: "index_tournaments_on_prereg_slug", unique: true
  end

  add_foreign_key "tournament_players", "players"
  add_foreign_key "tournament_players", "tournaments"
end
