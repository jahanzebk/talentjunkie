class ExternalFeedEntry < ActiveRecord::Base
  
  belongs_to :external_feed
  has_and_belongs_to_many :organizations
  
  named_scope :not_classified, :conditions => "classified = 0", :order => "published ASC"
  named_scope :not_reviewed, :conditions => "reviewed = 0", :order => "published ASC"

  validates_uniqueness_of :guid
  
  def self.update_from_feed(external_feed)
    feed = Feedzirra::Feed.fetch_and_parse(external_feed.feed_url)
    feed.sanitize_entries!
    add_entries(external_feed, feed.entries)
  end
  
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
  end
  
  private
  
  def self.add_entries(external_feed, entries)
      entries.each do |entry|
        unless exists? :guid => entry.id
          create!(
            :external_feed_id => external_feed.id,
            :title         => entry.title,
            :summary      => entry.summary,
            :content      => entry.content,
            :url          => entry.url,
            :published    => entry.published,
            :guid         => entry.id
          )
        end
      end
    end

end