require 'rubygems'
require 'optparse'
require 'rack'
require 'yaml'
require 'mysql'
require 'digest/md5'
require 'base64'
# require 'activerecord'
require 'uri'

RAILS_ROOT = "#{File.dirname(__FILE__)}/../.."
SERVER_ROOT = "#{File.dirname(__FILE__)}"

require SERVER_ROOT + '/logger'
require SERVER_ROOT + '/mysql_adapter'

module FullFabric

  class Server
  
    include FullFabric
  
    class UrlNotFound < StandardError; end
  
    ONE_YEAR_IN_SECONDS = 60 * 60 * 24 * 365
    SESSION_COOKIE_NAME = "_tjnkie_sess"
    USER_COOKIE_NAME = "_tjnkie_usr"
                         
    def initialize(*args)

      @options = {}
      @options[:environment] =  ENV["FF_ENV"] ? ENV["FF_ENV"] : "development"
      
      print "Starting FullFabric server in #{@options[:environment]} mode.\n"
      
      # load config file and get options for environment
      print "Loading config file... "
      options = File.open( "#{RAILS_ROOT}/config/server.yml" ) { |yf| YAML::load( yf ) }
      print "\t\t\t\t\tdone.\n"
      
      # url of this server, including port
      @options[:url] = options[@options[:environment]]["url"] ? options[@options[:environment]]["url"] : "localhost:3001"
      print "Server URL is #{@options[:url]}\n"
      
      details = _get_database_details
      print "cool\n"
      @mysql = get_mysql_connection(details )
      print "Initialization complete.\n"
    end
  
    def _get_database_details
      print "Loading db details for #{@options[:environment]} environment... "
      config = File.open( "#{RAILS_ROOT}/config/database.yml" ) { |yf| YAML::load( yf ) }
      print "\tdone.\n"
      config[@options[:environment]]
    end
  
    def get_mysql_connection(config) # :nodoc:
      print "Initializing database... \n"
      host     = config["host"]
      port     = config["port"]
      socket   = config["socket"]
      username = config["username"] ? config["username"].to_s : 'root'
      password = config["password"].to_s

      if config.has_key?("database")
        database = config["database"]
      else
        raise ArgumentError, "No database specified. Missing argument: database."
      end
      
      dbh = Mysql.init
      adapter = MysqlAdapter.new(dbh, [host, username, password, database, port, socket])
      print "\t\t\t\tdone.\n"
      adapter
    end
  
    def _include_generators
      require "#{SERVER_ROOT}/generator.rb"
      Dir.open("#{SERVER_ROOT}/generators").each { |entry| require "#{SERVER_ROOT}/generators/#{entry}" if entry.match(/\.rb$/) }
    end
  
    def call(env)
      begin
        request = Rack::Request.new(env)
        short_url_path = request.env["REQUEST_PATH"]
        
        begin
          result = @mysql.first("SELECT * FROM url_mappers WHERE short_url = '#{short_url_path}' LIMIT 1")
          raise UrlNotFound if result.nil?
          
          uri = result[1]
          
          response = Rack::Response.new("", 301, {'Location' => uri, 'Content-Type' => 'text/html; charset=utf-8', 'P3P' => 'CP="CUR ADM OUR NOR STA NID"'})
        
          session_hash = request.cookies[SESSION_COOKIE_NAME] ? request.cookies[SESSION_COOKIE_NAME] : Digest::MD5.new.update((Time.now + 30).to_f.to_s).to_s
          response.set_cookie(SESSION_COOKIE_NAME, session_hash) unless request.cookies[SESSION_COOKIE_NAME]
        
          user_hash = request.cookies[USER_COOKIE_NAME] ? request.cookies[USER_COOKIE_NAME] : Digest::MD5.new.update(Time.now.to_f.to_s).to_s
          response.set_cookie(USER_COOKIE_NAME, { :value => user_hash, :expires => Time.now + (60*60*24*365*10)}) unless request.cookies[USER_COOKIE_NAME]
          
          referrer = request.env['HTTP_REFERER'].nil? ? "" : request.env['HTTP_REFERER']
          
          # stats
          sql = "INSERT INTO url_mapper_raw_statistics VALUES ('#{uri}', '#{user_hash}', '#{session_hash}', '#{env["HTTP_USER_AGENT"]}', '#{referrer}', '#{Time.now.getutc.strftime('%Y-%m-%d %H:%M:%S')}')"
          @mysql.insert_sql(sql)

        rescue => e
          # raise e
          response = Rack::Response.new("404 Not found",404, { 'Content-Type' => "*/*",'Content-Length' => '0', 'P3P' => 'CP="CUR ADM OUR NOR STA NID"' })
        end
        response.finish
      rescue => e
        e.backtrace.each { |line| puts line }
        raise e.inspect
      end
    end
  end

  def _camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
  end

  def _underscore(camel_cased_word)
    camel_cased_word.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").downcase
  end

end

class Array
  def to_h(&block)
    Hash[*self.collect { |v| block.call(v) }.flatten]
  end
end


use Rack::ContentLength
run FullFabric::Server.new