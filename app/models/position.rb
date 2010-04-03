class Position < ActiveRecord::Base
  
  belongs_to :organization
  has_many :contracts
  has_many :openings, :class_name => "Contract", :conditions => "posted_by_user_id IS NOT NULL"

  validates_presence_of :organization
  validates_length_of :title, :in => 2..80
  validates_associated :organization, :message => "failed validation"
  
  # for organization
  named_scope :with_openings, :conditions => "contracts.id IS NOT NULL AND contracts.user_id IS NULL", :include => "contracts", :order => "contracts.from DESC"
  named_scope :with_openings_by, lambda { |user| { :conditions => [ "contracts.posted_by_user_id = ? AND contracts.id IS NOT NULL", user.id ], :include => "contracts", :order => "contracts.from DESC"}}
  # for user
  named_scope :current, lambda {{:conditions => "contracts.to IS NULL OR contract.to > #{Time.now.utc}"}}


  def organization_attributes=(attributes)
    if attributes[:id].present?
      @organization = Organization.find(attributes[:id])
      # @organization.update_attributes(attributes)
      self.organization = @organization
    else
      @organization = Organization.find_by_name(attributes[:name])
      if @organization
        self.organization = @organization
      else
        self.organization = Organization.new(attributes)
      end
    end
  end
  
  def openings_by(user)
    openings.all(:conditions => ["contracts.posted_by_user_id = ?", user.id])
  end
end
