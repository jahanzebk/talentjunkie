class Position < ActiveRecord::Base
  
  belongs_to :organization
  has_many :contracts
  
  has_many :openings, :class_name => "Contract", :conditions => "user_id IS NULL"
  
  # for organization
  named_scope :with_openings, :conditions => "contracts.id IS NOT NULL AND contracts.user_id IS NULL", :include => "contracts", :order => "contracts.from DESC"

  # for user
  named_scope :current, lambda {{:conditions => "contracts.to IS NULL OR contract.to > #{Time.now.utc}"}}
  
  validates_length_of :title, :in => 2..80, :allow_nil => true
end
