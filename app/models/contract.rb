class Contract < ActiveRecord::Base

  belongs_to :user
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_user_id"
  belongs_to :position
  
  def city; City.find(self[:cities_id]) if self[:cities_id]; end
  
  belongs_to :contract_type
  belongs_to :contract_periodicity_type
  belongs_to :contract_rate_type
  
  has_many :applications, :class_name => "JobApplication", :include => :applicant
  has_many :applicants, :through => :applications
  
  named_scope :current, lambda {{:conditions => "contracts.to > '#{Time.now.utc}' OR contracts.to IS NULL"}}
  named_scope :open ,   :conditions => "user_id IS NULL", :order => "updated_at DESC"
  
  def from=(year_then_month)
    year_then_month.nil? ? self[:from] = nil : self[:from] = DateTime.parse("#{year_then_month[0]}-#{year_then_month[1]}-01")
  end
  
  def to=(year_then_month)
    year_then_month.nil? ? self[:to] = nil : self[:to] = DateTime.parse("#{year_then_month[0]}-#{year_then_month[1]}-01") + 1.month - 1.second
  end
  
  def started_on_as_datetime
    raise
    DateTime.parse("#{from_year}-#{from_month}-01")
  end
  
  def description=(text)
    self[:description] = RedCloth.new(text || "")
    self[:description].sanitize_html = true
  end
  
  def benefits=(text)
    self[:benefits] = RedCloth.new(text || "")
    self[:benefits].sanitize_html = true
  end
  
end
