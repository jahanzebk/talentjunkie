class Note < ActiveRecord::Base
  belongs_to :user
  
  def content=(text)
    self[:content] = RedCloth.new(text || "")
    self[:content].sanitize_html = true
  end
end