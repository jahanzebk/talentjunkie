class Interest < ActiveRecord::Base
  belongs_to :user
  
  def description=(text)
    self[:description] = RedCloth.new(text || "")
    self[:description].sanitize_html = true
  end
end