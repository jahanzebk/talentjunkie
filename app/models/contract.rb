class Contract < ActiveRecord::Base
  belongs_to :person
  belongs_to :position
  
  belongs_to :contract_type
  belongs_to :contract_periodicity_type
  
  has_many :applications, :class_name => "JobApplication"
  has_many :applicants, :through => :applications
  
  named_scope :current, :conditions => "contracts.to_month IS NULL AND contracts.to_year IS NULL"
  named_scope :open , :conditions => "user_id IS NULL", :order => "updated_at DESC"
  
  validates_presence_of :position_id
  
  def started_on_as_datetime
    DateTime.parse("#{from_year}-#{from_month}-01")
  end
end
