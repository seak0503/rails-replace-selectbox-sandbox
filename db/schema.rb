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

ActiveRecord::Schema.define(version: 20170113102203) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "destgroups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "destgroups", ["name"], name: "index_destgroups_on_name", unique: true, using: :btree

  create_table "destgroups_orders", id: false, force: :cascade do |t|
    t.integer "destgroup_id", limit: 4, null: false
    t.integer "order_id",     limit: 4, null: false
  end

  add_index "destgroups_orders", ["destgroup_id"], name: "index_destgroups_orders_on_destgroup_id", using: :btree
  add_index "destgroups_orders", ["order_id"], name: "index_destgroups_orders_on_order_id", using: :btree

  create_table "destgroups_services", id: false, force: :cascade do |t|
    t.integer  "service_id",   limit: 4, null: false
    t.integer  "destgroup_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "destgroups_services", ["destgroup_id"], name: "index_destgroups_services_on_destgroup_id", using: :btree
  add_index "destgroups_services", ["service_id", "destgroup_id"], name: "index_destgroups_services_on_service_id_and_destgroup_id", unique: true, using: :btree
  add_index "destgroups_services", ["service_id"], name: "index_destgroups_services_on_service_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "category_id",     limit: 4
    t.integer  "sub_category_id", limit: 4
  end

  add_index "items", ["category_id", "sub_category_id"], name: "index_items_on_category_id_and_sub_category_id", using: :btree
  add_index "items", ["sub_category_id"], name: "index_items_on_sub_category_id", using: :btree

  create_table "order_categories", force: :cascade do |t|
    t.string   "order_category_key", limit: 255, null: false
    t.string   "name",               limit: 255, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "order_category_id", limit: 4
    t.text     "contract_number",   limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "orders", ["order_category_id"], name: "index_orders_on_order_category_id", using: :btree

  create_table "service_order_category_links", force: :cascade do |t|
    t.integer  "service_id",        limit: 4, null: false
    t.integer  "order_category_id", limit: 4, null: false
    t.integer  "display_order",     limit: 4, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "service_order_category_links", ["order_category_id"], name: "fk_rails_8cb4229b1d", using: :btree
  add_index "service_order_category_links", ["service_id", "order_category_id", "display_order"], name: "index_service_order_category_links_on_service_category_display", unique: true, using: :btree

  create_table "services", force: :cascade do |t|
    t.integer  "parent_service_id", limit: 4
    t.string   "service_key",       limit: 255, null: false
    t.string   "name",              limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "services", ["name"], name: "index_services_on_name", unique: true, using: :btree
  add_index "services", ["parent_service_id"], name: "index_services_on_parent_service_id", using: :btree
  add_index "services", ["service_key"], name: "index_services_on_service_key", unique: true, using: :btree

  create_table "sub_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "category_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "sub_categories", ["category_id"], name: "index_sub_categories_on_category_id", using: :btree

  add_foreign_key "destgroups_services", "destgroups"
  add_foreign_key "destgroups_services", "services"
  add_foreign_key "orders", "order_categories"
  add_foreign_key "service_order_category_links", "order_categories"
  add_foreign_key "service_order_category_links", "services"
  add_foreign_key "services", "services", column: "parent_service_id"
  add_foreign_key "sub_categories", "categories"
end
