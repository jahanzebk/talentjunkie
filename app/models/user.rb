class User < ActiveRecord::Base
  
  # acts_as_authentic do |config|
  #   config.login_field = :primary_email
  #   config.require_password_confirmation = false
  # end
  
  attr_accessible :primary_email, :password, :first_name, :last_name, :dob
  
  has_one :photo, :class_name => 'UserPhoto'
  has_one :detail, :class_name => 'UserDetail'
  
  has_many :emails
  has_many :contracts, :order => "contracts.from_year DESC, contracts.from_month DESC, contracts.to_year DESC, contracts.to_month DESC"
  has_many :positions, :through => :contracts
  has_many :postings, :class_name => 'Contract', :foreign_key => 'posted_by_user_id'
  has_many :applications, :class_name => 'JobApplication', :foreign_key => 'applicant_id'
  
  has_many :events, :class_name => "Events::Event", :foreign_key => "subject_id"
  has_many :newsfeed_items,        :class_name => "Events::Event", :finder_sql => '(SELECT events.* FROM events LEFT JOIN following_people ON(events.subject_type = "User" AND events.subject_id = following_people.followed_user_id) WHERE following_people.follower_user_id = #{id} OR events.subject_id = #{id}) UNION (SELECT events.* FROM events LEFT JOIN following_organizations ON(events.subject_type = "Organization" AND events.subject_id = following_organizations.organization_id) WHERE following_organizations.user_id = #{id}) ORDER BY created_at DESC'
  
  has_many :tweets, :order => "created_at DESC"
  
  # connections
  # has_many :pending_connections, :class_name => "User", :finder_sql => 'SELECT users.* FROM users LEFT JOIN connection_requests ON(connection_requests.requester_id = users.id OR connection_requests.acceptor_id = users.id) WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND users.id != #{id} AND connection_requests.state = 0'
  # has_many :connections,          :class_name => "ConnectionRequest", :finder_sql => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id})'
  # has_many :connections_pending,  :class_name => "ConnectionRequest", :finder_sql => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state = 0'
  # has_many :connections_accepted, :class_name => "ConnectionRequest", :finder_sql => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state = 1'
  # has_many :connections_ignored,  :class_name => "ConnectionRequest", :finder_sql => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state = 2'
  
  has_many :connections_to_people,                :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.followed_user_id) LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id) WHERE p1.follower_user_id = #{id} AND p2.follower_user_id IS NOT NULL ORDER BY p1.created_at DESC'
  has_many :following_people_but_not_connected,   :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.followed_user_id) LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id) WHERE p1.follower_user_id = #{id} AND p2.follower_user_id IS NULL ORDER BY p1.created_at DESC'
  has_many :followed_by_people_but_not_connected, :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.follower_user_id) LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id) WHERE p1.followed_user_id = #{id} AND p2.follower_user_id IS NULL ORDER BY p1.created_at DESC'
  
  has_many :following_organizations, :class_name => "Organization", :finder_sql => 'SELECT organizations.* FROM following_organizations LEFT JOIN organizations ON (organizations.id = following_organizations.organization_id) WHERE following_organizations.user_id = #{id} ORDER BY created_at DESC'
  
  # has_many :top_network_users, :class_name => "User", :finder_sql => 'SELECT users.* FROM users LEFT JOIN connection_requests ON(connection_requests.requester_id = users.id OR connection_requests.acceptor_id = users.id) WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND users.id != #{id} AND connection_requests.state = 1', :limit => 10
  # has_many :network_users, :class_name => "User", :finder_sql => 'SELECT users.* FROM users LEFT JOIN connection_requests ON(connection_requests.requester_id = users.id OR connection_requests.acceptor_id = users.id) WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND users.id != #{id} AND connection_requests.state = 1'
  
  has_many :diplomas
  
  validates_presence_of :first_name, :last_name
  validates_format_of :primary_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def title
    if contracts.first
      "#{contracts.first.position.title} at #{contracts.first.position.organization.name}"
    else
      ""
    end
  end
  
  def postings_for(organization)
    organization.positions.with_openings
  end
  
  def organizations
    Organization.find_by_sql("SELECT DISTINCT(o.id), o.* FROM contracts AS c LEFT JOIN positions AS p ON(c.position_id = p.id) LEFT JOIN organizations AS o ON(p.organization_id = o.id) WHERE c.user_id = #{id}")
  end

  def organizations_active
    Organization.find_by_sql("SELECT DISTINCT(o.id), o.* FROM contracts AS c LEFT JOIN positions AS p ON(c.position_id = p.id) LEFT JOIN organizations AS o ON(p.organization_id = o.id) WHERE c.user_id = #{id} AND c.to_month IS NULL AND c.to_year IS NULL")
  end

  def belongs_to?(organization)
    organizations_active.include?(organization)
  end
  
  def applied_to?(contract)
    applications.all(:conditions => "job_applications.contract_id = #{contract.id}").size > 0
  end
  
  def application_for(contract)
    applications.all(:conditions => "job_applications.contract_id = #{contract.id}").first
  end
  
  def contracts_at(organization)
    contracts.all(:conditions => "positions.organization_id = #{organization.id} AND contracts.position_id = positions.id", :include => :position)
  end
  
  def has_photo?
    self.photo
  end
  
  def get_photo_url
    if self.photo
      self.photo.public_filename
    else
      '/images/no_photo.gif'
    end
  end
  
  def is_following?(user)
    following_people_but_not_connected.include?(user) or connections_to_people.include?(user)
  end
  
  def is_following_organization?(organization)
    following_organizations.include?(organization)
  end
  
  def is_following_but_not_connected_to?(user)
    followin_people_only.include?(user)
  end
  
  def is_connected_to?(user)
    connections_to_people.include?(user)
  end
  
  def is_admin?
    is_admin == 1
  end
  
  def profile_views
    Stats::ProfileView.count(:conditions => "user_id = #{self.id} AND user_id != viewer_id")
  end
  
  def unique_profile_views
    Stats::ProfileView.count(:viewer_id, :conditions => "user_id = #{self.id} AND user_id != viewer_id")
  end
  
end
