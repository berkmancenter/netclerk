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

ActiveRecord::Schema.define(version: 20150421234131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "iso3"
    t.string   "local_dns"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iso2"
  end

  create_table "pages", force: true do |t|
    t.text     "url"
    t.string   "title"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["category_id"], name: "index_pages_on_category_id", using: :btree

  create_table "proxies", force: true do |t|
    t.string   "ip_and_port"
    t.boolean  "permanent"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proxies", ["country_id"], name: "index_proxies_on_country_id", using: :btree

  create_table "requests", force: true do |t|
    t.integer  "page_id"
    t.integer  "country_id"
    t.integer  "proxy_id"
    t.string   "unproxied_ip"
    t.string   "proxied_ip"
    t.string   "local_dns_ip"
    t.float    "response_time"
    t.integer  "response_status"
    t.text     "response_headers"
    t.integer  "response_length"
    t.float    "response_delta"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["country_id"], name: "index_requests_on_country_id", using: :btree
  add_index "requests", ["page_id"], name: "index_requests_on_page_id", using: :btree
  add_index "requests", ["proxy_id"], name: "index_requests_on_proxy_id", using: :btree

  create_table "statuses", force: true do |t|
    t.integer  "page_id"
    t.integer  "country_id"
    t.integer  "value"
    t.integer  "delta"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "request_ids", default: [], array: true
  end

  add_index "statuses", ["country_id"], name: "index_statuses_on_country_id", using: :btree
  add_index "statuses", ["page_id"], name: "index_statuses_on_page_id", using: :btree

end
