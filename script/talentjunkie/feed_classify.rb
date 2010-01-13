#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"
require 'classifier' #monkey pachtes array, doesnt work with ActiveRecord

class Logger
  def format_message(severity, timestamp, msg, progname)
    "#{severity.upcase} [#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}] - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end

# @log = Logger.new("#{RAILS_ROOT}/log/tweets.log", 10, 1024000)
@log = Logger.new(STDOUT)
@log.level = Logger::DEBUG




ExternalFeedEntry.all.each do |entry|
  Organization.all.each do |organization|
    if entry["summary"] and entry["summary"].match(organization["name"])
      ActiveRecord::Base.connection.execute("INSERT INTO external_feed_entries_organizations (external_feed_entry_id, organization_id) VALUES (#{entry['id']}, #{organization['id']})")
    end
  end
end

exit(0)

b = Classifier::Bayes.new

Organization.all.each do |org|
  b.add_category org["name"].downcase
  entries = ActiveRecord::Base.connection.select_all("SELECT title FROM external_feed_entries AS e LEFT JOIN external_feed_entries_organizations AS j ON(e.id = j.external_feed_entry_id) WHERE j.organization_id = #{org['id']}")
  entries.each do |entry|
    b.train(org["name"], entry["title"])
  end
end
 

b.train "google", "content1 is a google mix"
b.train "google", "google says so"

puts b.classify ExternalFeedEntry.find(1)["title"]

  # b.train organization_name ExternalFeedEntry.find(1).content

# @feeds.each do |feed|
#   @log.debug("Starting job for #{feed.feed_url}")
#   
#   ExternalFeedEntry.update_from_feed(feed)
#   
#   @log.debug("Completed job for #{feed.feed_url}")
#   @log.debug("------------------------------------------------------------------")
# end