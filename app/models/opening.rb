class Opening < ActiveRecord::Base

  include ActiveRecord::CustomNestedAttributes
  
  include SSM
  
  ssm_inject_state_into :state, :as_integer => true, :strategy => :active_record
  
  ssm_initial_state :new
  ssm_state :active
  ssm_state :closed

  ssm_event :activate, :from => [:new], :to => :active do
    save
  end
  # 
  # ssm_event :close, :from => [:open, :active], :to => :close do
  # end
  
  belongs_to :posted_by, :class_name => "User", :foreign_key => "posted_by_user_id"
  belongs_to :position
  belongs_to :city
  
  belongs_to :contract_type
  belongs_to :contract_periodicity_type
  belongs_to :contract_rate_type
  
  has_many :applications, :class_name => "JobApplication", :include => :applicant
  has_many :applicants, :through => :applications
  
  has_and_belongs_to_many :communities
  
  validates_presence_of :position
  custom_accepts_nested_attributes_for :position

  named_scope :active, :conditions => "state = 1", :order => "updated_at DESC"
  
  # services
  def opening_service; @opening_service ||= OpeningService.new(self); end
  
  def from=(attributes)
    if attributes[:start_asap].present?
      self[:from] = nil
    elsif attributes[:month] and attributes[:year]
      self[:from] = DateTime.parse("#{attributes[:year]}-#{attributes[:month]}-01")
    else
      self[:from] = nil
    end
  end
  
  def to=(attributes)
    if attributes[:month] and attributes[:year] and attributes[:open_ended].blank?
      self[:to] = DateTime.parse("#{attributes[:year]}-#{attributes[:month]}-01")
    else
      self[:to] = nil
    end
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
