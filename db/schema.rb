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

ActiveRecord::Schema.define(:version => 20081014213003) do

  create_table "cancers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.integer  "cancer_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gene_types", :force => true do |t|
    t.integer  "gene_id"
    t.integer  "cancer_id"
    t.string   "association"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genes", :force => true do |t|
    t.string   "gene_symbol"
    t.string   "swissprot"
    t.string   "genebank"
    t.string   "omim"
    t.string   "entrez"
    t.string   "orf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "genes_pathways", :id => false, :force => true do |t|
    t.integer "gene_id"
    t.integer "pathway_id"
  end

  create_table "interactions", :force => true do |t|
    t.string   "source"
    t.string   "experiment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gene_id"
    t.integer  "gene_id_target"
  end

  create_table "microarrays", :force => true do |t|
    t.integer  "experiment_id"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pathways", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proteins", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gene_id"
  end

  create_table "searches", :force => true do |t|
    t.string   "gene_symbol"
    t.string   "swissprot"
    t.string   "entrez"
    t.string   "synonym"
    t.string   "gene_type"
    t.string   "cancer_name"
    t.string   "interacts_with"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "synonyms", :force => true do |t|
    t.integer  "gene_id"
    t.string   "synonym"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transcription_factors", :force => true do |t|
    t.integer  "gene_id"
    t.integer  "gene_id_target"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive"
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
