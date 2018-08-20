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

ActiveRecord::Schema.define(version: 20180729092401) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "username"
    t.integer "status", limit: 2
    t.integer "role"
    t.string "phone"
    t.string "tel"
    t.string "qq"
    t.string "fax"
    t.text "desc"
    t.integer "sns_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["phone"], name: "index_admins_on_phone"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "code"
    t.integer "seq"
    t.integer "zone", limit: 1
    t.integer "status", limit: 1
    t.integer "parent_id"
    t.integer "depth"
    t.integer "lft"
    t.integer "rgt"
    t.integer "children_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_areas_on_code"
    t.index ["depth"], name: "index_areas_on_depth"
    t.index ["lft"], name: "index_areas_on_lft"
    t.index ["name"], name: "index_areas_on_name"
    t.index ["parent_id"], name: "index_areas_on_parent_id"
    t.index ["rgt"], name: "index_areas_on_rgt"
    t.index ["zone"], name: "index_areas_on_zone"
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file_name"
    t.string "content_type"
    t.string "file_size"
    t.string "attachmentable_type"
    t.integer "attachmentable_id"
    t.string "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "catgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "en_name"
    t.integer "seq"
    t.integer "status", limit: 1
    t.text "ext"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_catgs_on_name", unique: true
  end

  create_table "simple_captcha_data", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "key", limit: 40
    t.string "value", limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "idx_key"
  end

  create_table "sns_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "admin_id"
    t.integer "platform"
    t.string "scope"
    t.string "union_id"
    t.string "openid"
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "authorized_at"
    t.string "refresh_token"
    t.text "user_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_sns_accounts_on_admin_id"
    t.index ["openid"], name: "index_sns_accounts_on_openid"
    t.index ["union_id"], name: "index_sns_accounts_on_union_id"
  end

  create_table "tag_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "en_name"
    t.integer "seq"
    t.integer "status", limit: 1
    t.bigint "catg_id"
    t.text "ext"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catg_id"], name: "index_tag_keys_on_catg_id"
    t.index ["name"], name: "index_tag_keys_on_name", unique: true
  end

  add_foreign_key "tag_keys", "catgs"
end
