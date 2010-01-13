#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"
require 'open-uri'

class Logger
  def format_message(severity, timestamp, msg, progname)
    "#{severity.upcase} [#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}] - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end


@log = Logger.new("#{RAILS_ROOT}/log/tweets.log", 10, 1024000)
@log.level = Logger::DEBUG



@users_with_twitter_enabled = User.all(:conditions => "twitter_handle IS NOT NULL")

@users_with_twitter_enabled.each do |user|
  @log.debug("Starting job for #{user.full_name} (@#{user.twitter_handle})")
  last_recorded_tweet = user.tweets.first
  if last_recorded_tweet.present?
    @log.debug("Retrieving tweets after #{last_recorded_tweet.created_at}")
    buffer = open("http://twitter.com/statuses/user_timeline/#{user.twitter_handle}.json?count=200&since_id=#{last_recorded_tweet.twitter_id}").read
  else
    @log.debug("Retrieving tweets for the first time for this user")
    buffer = open("http://twitter.com/statuses/user_timeline/#{user.twitter_handle}.json?count=200").read
  end
  
  tweets = JSON.parse(buffer)
  
  @log.debug("Found #{tweets.size} tweets")
  
  tweets.each do |t|
    tweet = Tweet.new
    tweet.attribute_names.each do |attr|
      tweet[attr.to_sym] = t[attr]
    end
    tweet.twitter_id = t["id"]    
    tweet.user_id = user.id
    tweet.save!
  end
  
  tweets.each do |t|
    tweet = Events::PersonTweet.new
    tweet.subject_id = user.id
    tweet.content = t["text"]
    tweet.created_at = t["created_at"]
    tweet.save!
  end
  
  @log.debug("Completed job for #{user.full_name} (@#{user.twitter_handle})")
  @log.debug("------------------------------------------------------------------")
end