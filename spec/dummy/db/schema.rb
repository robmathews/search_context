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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130625031608) do

  create_table "authors", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.tsvector "names_vector"
  end

  add_index "authors", ["names_vector"], :name => "idx_names_vector_on_authors"

  create_table "foos", :force => true do |t|
    t.string   "field1"
    t.string   "field2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

# Could not dump table "name_aliases" because of following StandardError
#   Unknown type 'tsquery' for column 'original'

  create_table "names", :force => true do |t|
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "names", ["name"], :name => "idx_trgm_on_name_words"

# Could not dump table "varietal_aliases" because of following StandardError
#   Unknown type 'tsquery' for column 'original_tsquery'

  create_table "varietals", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "varietals", ["name"], :name => "idx_trgm_on_varietals"

end
