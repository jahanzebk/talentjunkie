class Organization < ActiveRecord::Base

  belongs_to :industry
  has_many :positions
  has_many :contracts, :through => :positions
  has_many :degrees
  has_many :offices, :class_name => 'OrganizationOffice'
  has_one :logo, :class_name => 'OrganizationLogo'
  
  has_many :followed_by_people, :class_name => "User", :finder_sql => 'SELECT users.* FROM following_organizations LEFT JOIN users ON (users.id = following_organizations.user_id) WHERE following_organizations.organization_id = #{id}'
  
  validates_uniqueness_of :name, :case_sensitive => false
  validates_length_of :name, :in => 2..80, :allow_nil => true

  def feed_service; @feed_service ||= OrganizationFeedService.new(self); end

  def self.find_or_create_organization_by_name(params)
    organization = Organization.find_by_name(params[:name])
    unless organization
      organization = Organization.new(:name => params[:name])
      organization.save!
    end
    organization
  end


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
  
  def self.find_by_id_or_handle!(id_or_handle)
    begin
      self.find(id_or_handle)
    rescue
      self.find_by_handle!(id_or_handle, :conditions => "handle IS NOT NULL")
    end
  end
  
  def summary=(text)
    self[:summary] = RedCloth.new(text || "")
    self[:summary].sanitize_html = true
  end
end
