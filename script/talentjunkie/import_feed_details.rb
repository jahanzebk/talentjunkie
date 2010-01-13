#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"
require 'feedzirra'
require 'csv'

class Logger
  def format_message(severity, timestamp, msg, progname)
    "#{severity.upcase} [#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}] - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end

# @log = Logger.new("#{RAILS_ROOT}/log/tweets.log", 10, 1024000)
@log = Logger.new(STDOUT)
@log.level = Logger::DEBUG


@feeds =  CSV::Reader.parse(File.open(RAILS_ROOT + "/db/feeds.csv", 'r'))

@feeds.each do |feed_details|
  feed = Feedzirra::Feed.fetch_and_parse(feed_details[0])

  external_feed = ExternalFeed.new
  external_feed.feed_url = feed.feed_url
  external_feed.url = feed.url
  external_feed.title = feed.title
  external_feed.save
end