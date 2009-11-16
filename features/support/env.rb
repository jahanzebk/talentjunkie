# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'

# Comment out the next line if you don't want transactions to
# open/roll back around each scenario
Cucumber::Rails.use_transactional_fixtures

# Comment out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
Cucumber::Rails.bypass_rescue


if ENV['CUCUMBER_ENV'] == 'watir'
  # require 'rubygems'
  require '/Users/luis/Projects/watircuke/lib/watircuke.rb'
  require File.expand_path(File.dirname(__FILE__) + '/paths.rb')

  system 'rake db:migrate:reset > /dev/null'

  Before do
    require 'safariwatir'
    @browser = Watir::Safari.new
    @base_url = "http://localhost:3001"
  end
  
  # optional
  # at_exit do
  #   @browser.close
  # end
else
  require 'webrat'
  Webrat.configure do |config|
    config.mode = :rails
  end
  require 'cucumber/rails/rspec'
  require 'webrat/core/matchers'
  
  require 'rubygems'
  require '/Users/luis/Projects/watircuke/lib/webratcuke.rb'
  require File.expand_path(File.dirname(__FILE__) + '/paths.rb')
  
  Before do
    @base_url = ""
  end
end
