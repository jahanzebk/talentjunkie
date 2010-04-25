#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/boot'
require "#{RAILS_ROOT}/config/environment"

class Logger
  def format_message(severity, timestamp, msg, progname)
    "#{severity.upcase} [#{Time.now.strftime("%m-%d-%Y %H:%M:%S")}] - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end

@log = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}.log", 10, 1024000)

source = Organization.find(ARGV[0])
target = Organization.find(ARGV[1])

ActiveRecord::Base.connection.execute("UPDATE positions SET organization_id = #{target.id} WHERE organization_id = #{source.id}")
ActiveRecord::Base.connection.execute("UPDATE degrees SET organization_id = #{target.id} WHERE organization_id = #{source.id}")
ActiveRecord::Base.connection.execute("UPDATE events SET subject_id = #{target.id} WHERE subject_type = 'Organization' AND subject_id = #{source.id}")
ActiveRecord::Base.connection.execute("UPDATE events SET object_id = #{target.id} WHERE object_type = 'Organization' AND object_id = #{source.id}")
ActiveRecord::Base.connection.execute("UPDATE following_organizations SET organization_id = #{target.id} WHERE organization_id = #{source.id}")