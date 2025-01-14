# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150624143542) do

  create_table "missing_text_batches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missing_text_entries", force: true do |t|
    t.integer  "missing_text_records_id"
    t.string   "base_language"
    t.string   "base_string"
    t.text     "target_languages"
    t.string   "locale_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missing_text_records", force: true do |t|
    t.string   "parent_dir"
    t.text     "files"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "missing_text_batch_id"
  end

  add_index "missing_text_records", ["missing_text_batch_id"], name: "index_missing_text_records_on_missing_text_batch_id"

  create_table "missing_text_warnings", force: true do |t|
    t.string   "filename"
    t.string   "warning_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "missing_text_batch_id"
  end

  add_index "missing_text_warnings", ["missing_text_batch_id"], name: "index_missing_text_warnings_on_missing_text_batch_id"

end
