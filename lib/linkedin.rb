require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'
require '../config/environment.rb'

# doc = Hpricot(open("http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html"))
doc = open("luiscorreadalmeida.html") { |f| Hpricot(f)}

@user = User.new
@user.first_name = (doc/"#nameplate span.given-name").inner_html
@user.last_name = (doc/"#nameplate span.family-name").inner_html

(doc/"#experience ul.vcalendar//li").each do |li|
  
  position = Position.new
  position.title = CGI.unescapeHTML((li/"h3.title").inner_html.strip)
  # position.org = CGI.unescapeHTML((li/"h4.org a").inner_html.strip)
  
  contract = Contract.new
  # contract.position_id = 
  
  (li/"abbr.dtstart").each do |date|
    if date.attributes['title'].length == 4
      contract.from_month = 1
      contract.from_year = date.attributes['title']
    else
      start_date = DateTime.parse(date.attributes['title'])
      contract.from_month = start_date.month
      contract.from_year = start_date.year
    end
  end
  
  (li/"abbr.dtend").each do |date|
    if date.attributes['title'].length == 4
      contract.to_month = 1
      contract.to_year = date.attributes['title']
    else
      end_date = DateTime.parse(date.attributes['title'])
      contract.to_month = end_date.month
      contract.to_year = end_date.year
    end
  end
  
  @user.positions << position
end

puts @user.inspect
