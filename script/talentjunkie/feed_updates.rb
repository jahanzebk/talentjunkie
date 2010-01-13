#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"
require 'feedzirra'

class Logger
  def format_message(severity, timestamp, msg, progname)
    "#{severity.upcase} [#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}] - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end

# @log = Logger.new("#{RAILS_ROOT}/log/tweets.log", 10, 1024000)
@log = Logger.new(STDOUT)
@log.level = Logger::DEBUG

# ExternalFeedEntry.delete_all

@feeds = ExternalFeed.all

@feeds.each do |feed|
  @log.debug("Starting job for #{feed.feed_url}")
  
  ExternalFeedEntry.update_from_feed(feed)
  
  @log.debug("Completed job for #{feed.feed_url}")
  @log.debug("------------------------------------------------------------------")
end