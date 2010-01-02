class Note < ActiveRecord::Base
  belongs_to :user
  
  def content=(text)
    self[:summary] = RedCloth.new(text || "")
    self[:summary].sanitize_html = true
  end
end