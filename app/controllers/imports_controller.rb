require 'open-uri'
require 'hpricot'
class ImportsController < ApplicationController
  
  def index
    render :new
  end
  
  def new
  end
  
  def create
    @linkedin_url = params[:linkedin_public_profile_url]
    # @linkedin_url = "lib/warrentudor.html"
    
    doc = open(@linkedin_url) { |f| Hpricot(f)}

    @user = User.new
    @user.first_name = (doc/"#nameplate span.given-name").inner_html
    @user.last_name = (doc/"#nameplate span.family-name").inner_html

    (doc/"#experience ul.vcalendar//li").each do |li|

      @position = Position.new
      @position.title = CGI.unescapeHTML((li/"h3.title").inner_html.strip)
      
      @organization = Organization.new
      @organization.name = CGI.unescapeHTML((li/"h4.org a").inner_html.strip)
      @organization.name = CGI.unescapeHTML((li/"h4.org").inner_html.strip) if @organization.name.blank?

      @contract = Contract.new
      # contract.position_id = 

      (li/"abbr.dtstart").each do |date|
        if date.attributes['title'].length == 4
          @contract.from_month = 1
          @contract.from_year = date.attributes['title']
        else
          start_date = DateTime.parse(date.attributes['title'])
          @contract.from_month = start_date.month
          @contract.from_year = start_date.year
        end
      end

      (li/"abbr.dtend").each do |date|
        if date.attributes['title'].length == 4
          @contract.to_month = 1
          @contract.to_year = date.attributes['title']
        else
          end_date = DateTime.parse(date.attributes['title'])
          @contract.to_month = end_date.month
          @contract.to_year = end_date.year
        end
      end
      
      @position.organization = @organization
      @position.contracts << @contract
      @user.positions << @position
    end
    
    edu = []
    
    # education
    (doc/"#education ul.vcalendar//li").each do |li|
      
      @organization = Organization.new
      @organization.name = CGI.unescapeHTML((li/"h3.summary").inner_html.strip)

      @degree = Degree.new
      @degree.degree = "#{CGI.unescapeHTML((li/"span.degree").inner_html.strip)} - #{CGI.unescapeHTML((li/"span.major").inner_html.strip)}"
      
      @diploma = Diploma.new

      (li/"abbr.dtstart").each do |date|
        if date.attributes['title'].length == 4
          @diploma.from_month = 1
          @diploma.from_year = date.attributes['title']
        else
          start_date = DateTime.parse(date.attributes['title'])
          @diploma.from_month = start_date.month
          @diploma.from_year = start_date.year
        end
      end

      (li/"abbr.dtend").each do |date|
        if date.attributes['title'].length == 4
          @diploma.to_month = 1
          @diploma.to_year = date.attributes['title']
        else
          end_date = DateTime.parse(date.attributes['title'])
          @diploma.to_month = end_date.month
          @diploma.to_year = end_date.year
        end
      end
      
      @degree.organization = @organization
      @diploma.degree = @degree
      @user.diplomas << @diploma
    end
    
    render :new
  end
  
end
