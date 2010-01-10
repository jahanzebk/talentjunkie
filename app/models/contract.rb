class Contract < ActiveRecord::Base
  belongs_to :user
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_user_id"
  belongs_to :position
  
  def city
    City.find(self[:cities_id]) if self[:cities_id]
  end
  
  belongs_to :contract_type
  belongs_to :contract_periodicity_type
  belongs_to :contract_rate_type
  
  has_many :applications, :class_name => "JobApplication", :include => :applicant
  has_many :applicants, :through => :applications
  
  # this needs to include the case where the to dates are set in the future
  named_scope :current, :conditions => "(contracts.to_month IS NULL AND contracts.to_year IS NULL)  AND contracts.user_id IS NOT NULL"
  named_scope :open , :conditions => "user_id IS NULL", :order => "updated_at DESC"
  
  def started_on_as_datetime
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
