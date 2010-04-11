class ExternalFeed < ActiveRecord::Base
  has_many :entries, :class_name => "ExternalFeedEntry", :order => "published ASC"
  has_and_belongs_to_many :communities, :join_table => "external_feeds_communities", :conditions => "auto_publish = 1"
  validates_uniqueness_of :url, :feed_url
  
end