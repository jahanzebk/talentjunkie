class Contract < ActiveRecord::Base

  belongs_to :user
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_user_id"
  belongs_to :position
  belongs_to :city
  
  belongs_to :contract_type
  belongs_to :contract_periodicity_type
  belongs_to :contract_rate_type
  
  has_many :applications, :class_name => "JobApplication", :include => :applicant
  has_many :applicants, :through => :applications
  
  validates_presence_of :position
  validates_associated :position, :message => "failed validation"  
  
  
  named_scope :current, lambda {{:conditions => "user_id IS NOT NULL AND (contracts.to > '#{Time.now.utc}' OR contracts.to IS NULL)"}}
  named_scope :open ,   :conditions => "user_id IS NULL", :order => "updated_at DESC"
  
  # services
  def opening_service; @opening_service ||= OpeningService.new(self); end
  
  def position_attributes=(attributes)
    if attributes[:id].present?
      self.position.update_attributes(attributes)
    else
      self.position = Position.new(attributes)
    end
  end
  
  def from=(attributes)
    if attributes[:start_asap].present?
      self[:from] = DateTime.now.utc
    elsif attributes[:month] and attributes[:year]
      self[:from] = DateTime.parse("#{attributes[:year]}-#{attributes[:month]}-01")
    else
      self[:from] = nil
    end
  end
  
  def to=(attributes)
    if attributes[:month] and attributes[:year] and !attributes[:open_ended].present?
      self[:to] = DateTime.parse("#{attributes[:year]}-#{attributes[:month]}-01")
    else
      self[:to] = nil
    end
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
