# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091228023729) do

  create_table "cities", :force => true do |t|
    t.integer "country_id"
    t.string  "name"
  end

  add_index "cities", ["country_id"], :name => "country_id_index"
  add_index "cities", ["name"], :name => "city_initials_index"

  create_table "connection_requests", :force => true do |t|
    t.integer  "state",        :default => 0
    t.integer  "requester_id"
    t.integer  "acceptor_id"
    t.datetime "requested_at"
    t.datetime "accepted_at"
  end

  create_table "contract_periodicity_types", :force => true do |t|
    t.string "name"
  end

  create_table "contract_rate_types", :force => true do |t|
    t.string "name"
  end

  create_table "contract_types", :force => true do |t|
    t.string "name"
  end

  create_table "contracts", :force => true do |t|
    t.integer  "contract_type_id"
    t.integer  "contract_periodicity_type_id"
    t.integer  "contract_rate_type_id"
    t.integer  "rate"
    t.integer  "position_id"
    t.text     "description"
    t.text     "benefits"
    t.integer  "user_id"
    t.integer  "from_month"
    t.integer  "from_year"
    t.integer  "to_month"
    t.integer  "to_year"
    t.integer  "posted_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cities_id",                    :default => 2094941
  end

  create_table "countries", :force => true do |t|
    t.string "iso_code", :limit => 2
    t.string "name"
  end

  create_table "degrees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "degree"
    t.string   "major"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diplomas", :force => true do |t|
    t.integer  "degree_id"
    t.integer  "user_id"
    t.integer  "from_month"
    t.integer  "from_year"
    t.integer  "to_month"
    t.integer  "to_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "object_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject_type", :default => "User"
    t.string   "object_type",  :default => "User"
  end

  create_table "following_organizations", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "following_people", :id => false, :force => true do |t|
    t.integer  "follower_user_id"
    t.integer  "followed_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "industries", :force => true do |t|
    t.string "name"
  end

  create_table "job_application_phases", :force => true do |t|
    t.string "name"
    t.string "label"
    t.string "description"
  end

  create_table "job_applications", :force => true do |t|
    t.integer  "contract_id"
    t.integer  "applicant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_application_phase_id", :default => 1
  end

  create_table "organization_logos", :force => true do |t|
    t.integer  "organization_id"
    t.string   "filename"
    t.string   "content_type"
    t.datetime "uploaded_on"
    t.integer  "uploaded_by_user_id"
    t.string   "description"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "organization_profile_views", :id => false, :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "organization_id"
    t.datetime "created_at"
  end

  create_table "organization_statuses", :force => true do |t|
    t.string "name"
  end

  create_table "organizations", :force => true do |t|
    t.integer "industry_id"
    t.integer "organization_status_id", :default => 1
    t.string  "name"
    t.integer "year_founded"
    t.text    "summary"
    t.string  "handle"
  end

  create_table "positions", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_views", :id => false, :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "tweets", :primary_key => "twitter_id", :force => true do |t|
    t.integer  "user_id"
    t.string   "text"
    t.integer  "truncated"
    t.integer  "in_reply_to_status_id",   :limit => 8
    t.integer  "in_reply_to_user_id",     :limit => 8
    t.string   "in_reply_to_screen_name"
    t.datetime "created_at"
  end

  create_table "user_details", :force => true do |t|
    t.integer  "user_id"
    t.text     "summary"
    t.datetime "dob"
    t.integer  "cities_id", :default => 2094941
  end

  create_table "user_emails", :force => true do |t|
    t.integer "user_id"
    t.string  "email"
    t.integer "primary"
  end

  create_table "user_photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "filename"
    t.string   "content_type"
    t.datetime "uploaded_on"
    t.integer  "uploaded_by_user_id"
    t.string   "description"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "users", :force => true do |t|
    t.string   "primary_email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "dob"
    t.string   "facebook_uid"
    t.string   "type",              :default => "SimpleUser"
    t.string   "handle"
    t.string   "locale",            :default => "en"
    t.integer  "is_admin",          :default => 0
    t.string   "twitter_handle"
  end

end
