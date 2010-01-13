class Organization < ActiveRecord::Base

  has_many :degrees

  belongs_to :industry
  has_many :positions
  has_many :contracts, :through => :positions

  has_many :offices, :class_name => 'OrganizationOffice'
  has_one :logo, :class_name => 'OrganizationLogo'
  
  has_many :events, :class_name => "Events::Event", :foreign_key => "subject_id", :order => "created_at DESC"
  # has_many :newsfeed_items,        :class_name => "Events::Event", :finder_sql => '(SELECT events.* FROM events LEFT JOIN following_people ON(events.subject_type = "User" AND events.subject_id = following_people.followed_user_id) WHERE following_people.follower_user_id = #{id} OR events.subject_id = #{id}) UNION (SELECT events.* FROM events LEFT JOIN following_organizations ON(events.subject_type = "Organization" AND events.subject_id = following_organizations.organization_id) WHERE following_organizations.user_id = #{id}) ORDER BY created_at DESC',
  #                                                                  :counter_sql => '(SELECT events.* FROM events LEFT JOIN following_people ON(events.subject_type = "User" AND events.subject_id = following_people.followed_user_id) WHERE following_people.follower_user_id = #{id} OR events.subject_id = #{id}) UNION (SELECT events.* FROM events LEFT JOIN following_organizations ON(events.subject_type = "Organization" AND events.subject_id = following_organizations.organization_id) WHERE following_organizations.user_id = #{id})'
  
  
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
