class ExternalFeed < ActiveRecord::Base
  has_many :entries, :class_name => "ExternalFeedEntry"
  
  validates_uniqueness_of :url, :feed_url
end