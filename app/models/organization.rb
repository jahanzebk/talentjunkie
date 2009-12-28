class Organization < ActiveRecord::Base

  has_many :degrees

  belongs_to :industry
  has_many :positions
  has_many :contracts, :through => :positions

  has_one :logo, :class_name => 'OrganizationLogo'
  
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :in => 2..80, :allow_nil => true

  has_many :followed_by_people, :class_name => "User", :finder_sql => 'SELECT users.* FROM following_organizations LEFT JOIN users ON (users.id = following_organizations.user_id) WHERE following_organizations.organization_id = #{id}'

  def get_logo_url
    if self.logo
      self.logo.public_filename
    else
      '/images/no_logo.png'
    end
  end

  def profile_views
    Stats::OrganizationProfileView.count(:conditions => "organization_id = #{self.id} AND organization_id != viewer_id")
  end
  
  def unique_profile_views
    Stats::OrganizationProfileView.count(:viewer_id, :conditions => "organization_id = #{self.id} AND organization_id != viewer_id")
  end
  
end
