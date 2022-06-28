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

ActiveRecord::Schema[7.0].define(version: 2022_06_28_063404) do
  create_table "changelogs", charset: "utf8mb4", force: :cascade do |t|
    t.integer "change_type", null: false
    t.integer "player_type", null: false
    t.string "oldvalues"
    t.string "newvalues"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "row_id"
  end

  create_table "players", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "vekn", limit: 7
    t.string "country", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vekn"], name: "index_players_on_vekn", unique: true
  end

  create_table "tournament_players", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "vekn", limit: 7
    t.boolean "decklist", default: false, null: false
    t.boolean "prereg", default: false, null: false
    t.bigint "player_id", null: false
    t.bigint "tournament_id", null: false
    t.index ["tournament_id"], name: "index_tournament_players_on_tournament_id"
  end

  create_table "tournaments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 40, null: false
    t.string "location", limit: 80
    t.string "organizers", limit: 120
    t.date "date"
    t.boolean "decklists", default: false, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
