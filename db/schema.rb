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

ActiveRecord::Schema[8.0].define(version: 2025_05_29_182514) do
  create_table "thread_colors", force: :cascade do |t|
    t.string "dmc", null: false
    t.string "anchor"
    t.string "madeira"
    t.string "cosmo"
    t.string "olympus"
    t.string "jp_coats"
    t.string "sullivans"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "presenica"
    t.string "appletons"
    t.string "kreinik"
    t.string "luca_s"
    t.string "semco"
    t.string "y_d"
    t.index ["anchor"], name: "index_thread_colors_on_anchor"
    t.index ["cosmo"], name: "index_thread_colors_on_cosmo"
    t.index ["dmc"], name: "index_thread_colors_on_dmc", unique: true
    t.index ["jp_coats"], name: "index_thread_colors_on_jp_coats"
    t.index ["madeira"], name: "index_thread_colors_on_madeira"
    t.index ["olympus"], name: "index_thread_colors_on_olympus"
    t.index ["sullivans"], name: "index_thread_colors_on_sullivans"
  end
end
