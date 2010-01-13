class CreateUrlMappers < ActiveRecord::Migration
  def self.up
    create_table :url_mappers, :id => false, :options => 'DEFAULT CHARACTER SET latin1 COLLATE latin1_bin' do |t|
      t.string :short_url
      t.string :original_url
    end
    
    add_index(:url_mappers, :short_url, :unique => true)
    

    create_table :url_mapper_raw_statistics, :id => false do |t|
      t.string :short_url, :primary_key => true
      t.string :user_hash
      t.string :session_hash
      t.string :http_user_agent
      t.string :referrer
      t.datetime :datetime
    end    
    
    create_table :url_mapper_statistics, :id => false do |t|
      t.string :short_url, :primary_key => true
      t.integer :date_dim_id
      t.integer :clicks
    end
    
  end

  def self.down
    drop_table :url_mapper_statistics
    drop_table :url_mapper_raw_statistics
    drop_table :url_mappers
  end
end
