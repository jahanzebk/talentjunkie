class User < ActiveRecord::Base

  validates_presence_of :first_name, :last_name
  validates_format_of :primary_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates_length_of :handle, :in => 2..50, :message => "must be between 2 and 50 characters long"
  validates_uniqueness_of :handle, :allow_nil => false, :allow_blank => false, :case_sensitive => false
  validates_format_of :handle, :with => /^[a-z]/i, :message => "must start with a letter"
  validates_uniqueness_of :primary_email, :case_sensitive => false

  def before_validation_on_create
    self[:handle] = "a#{UUIDTools::UUID.timestamp_create}" unless self[:handle].present? # must start with a letter
  end
  
  def error_namespace
    "user"
  end
  
  # acts_as_authentic do |config|
  #   config.login_field = :primary_email
  #   config.require_password_confirmation = false
  # end
  
  attr_accessible :primary_email, :password, :first_name, :last_name, :dob

  # profile
  has_one :photo, :class_name => 'UserPhoto'
  has_one :detail, :class_name => 'UserDetail'
  has_one :settings, :class_name => 'UserSetting'
  has_many :emails
  
  # experience and education
  has_many :contracts, :order => "contracts.from DESC, contracts.to DESC"
  has_many :positions, :through => :contracts
  has_many :diplomas, :order => "diplomas.from DESC, diplomas.to DESC"
  has_many :interests
  
  #communities
  has_and_belongs_to_many :communities
    
  # recruitment
  has_many :openings, :class_name => 'Opening', :foreign_key => 'posted_by_user_id'
  has_many :applications, :class_name => 'JobApplication', :foreign_key => 'applicant_id'

  # connections
  has_many :connections_to_people,                :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id AND p2.followed_user_id = p1.follower_user_id) LEFT JOIN users ON(p1.followed_user_id = users.id) WHERE p1.follower_user_id = #{id} AND p2.follower_user_id IS NOT NULL ORDER BY users.created_at DESC'
  has_many :following_people_but_not_connected,   :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.followed_user_id) LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id) WHERE p1.follower_user_id = #{id} AND p2.follower_user_id IS NULL ORDER BY p1.created_at DESC'
  has_many :followed_by_people_but_not_connected, :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.follower_user_id) LEFT JOIN following_people AS p2 ON (p1.followed_user_id = p2.follower_user_id) WHERE p1.followed_user_id = #{id} AND p2.follower_user_id IS NULL ORDER BY p1.created_at DESC'
  has_many :following_people,                     :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.followed_user_id) WHERE p1.follower_user_id = #{id} ORDER BY p1.created_at DESC'
  has_many :followed_by_people,                   :class_name => "User", :finder_sql => 'SELECT users.* FROM following_people AS p1 LEFT JOIN users ON (users.id = p1.follower_user_id) WHERE p1.followed_user_id = #{id} ORDER BY p1.created_at DESC'
  has_many :following_organizations, :class_name => "Organization", :finder_sql => 'SELECT organizations.* FROM following_organizations LEFT JOIN organizations ON (organizations.id = following_organizations.organization_id) WHERE following_organizations.user_id = #{id} ORDER BY created_at DESC'
  
  # events
  # has_many :events, :class_name => "Events::Event", :foreign_key => "subject_id"
  has_many :tweets, :order => "created_at DESC"
  
  # achievement
  def achievement
    @achievement ||= Achievement.find_by_sql("SELECT achievements.* FROM achievements LEFT JOIN achievement_steps ON(achievements.id = achievement_steps.achievement_id) LEFT JOIN achievement_steps_users ON (achievement_steps_users.achievement_step_id = achievement_steps.id AND achievement_steps_users.user_id = #{id}) WHERE achievement_steps_users.user_id IS NULL ORDER BY achievement_steps.achievement_id ASC LIMIT 1")[0]
  end  
  
  def next_achievement
    Achievement.find(achievement.id + 1) if achievement
  end
  
  def steps_for_achievement(achievement)
    AchievementStep.find_by_sql("SELECT achievement_steps.* FROM achievement_steps LEFT JOIN achievement_steps_users ON (achievement_steps.achievement_id = #{achievement.id} AND achievement_steps.id = achievement_steps_users.achievement_step_id) WHERE achievement_steps_users.user_id = #{id}")
  end
  
  has_and_belongs_to_many :steps, :class_name => "AchievementStep"
  
  # services
  def service; @service ||= UserService.new(self); end
  def feed_service; @feed_service ||= UserFeedService.new(self); end
  
  def full_name; "#{first_name} #{last_name}"; end
  
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
  
  def notes_for(user)
    Note.find_by_sql("SELECT notes.* FROM notes WHERE user_id = #{id} AND object_id = #{user.id} ORDER BY notes.created_at DESC")
  end
  
  def organizations
    Organization.find_by_sql("SELECT DISTINCT(o.id), o.* FROM contracts AS c LEFT JOIN positions AS p ON(c.position_id = p.id) LEFT JOIN organizations AS o ON(p.organization_id = o.id) WHERE c.user_id = #{id}")
  end

  def organizations_active
    Organization.find_by_sql("SELECT DISTINCT(o.id), o.* FROM contracts AS c LEFT JOIN positions AS p ON(c.position_id = p.id) LEFT JOIN organizations AS o ON(p.organization_id = o.id) WHERE c.user_id = #{id} AND (c.to IS NULL OR c.to > '#{Time.now.utc}') ORDER BY o.name ASC")
  end

  def belongs_to?(organization)
    organizations_active.include?(organization)
  end
  
  def has_joined?(community)
    communities.include?(community)
  end
  
  def applied_to?(opening)
    applications.all(:conditions => "job_applications.opening_id = #{opening.id}").size > 0
  end
  
  def applications_to_a_job_by(user)
    applications.all(:conditions => "contracts.posted_by_user_id = #{user.id}", :include => "contract")
  end
  
  def posts_for(organization)
    Contract.find_by_sql("SELECT contracts.* FROM contracts LEFT JOIN positions ON(contracts.position_id = positions.id) WHERE positions.organization_id = #{organization.id} AND contracts.posted_by_user_id = #{id} ORDER BY contracts.created_at DESC, positions.title ASC")
  end
  
  def application_for(opening)
    applications.all(:conditions => "job_applications.opening_id = #{opening.id}").first
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
    following_people.include?(user)
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
  
  def is_public
    Achievement.find(1).is_completed_for(self)
  end

  def years_of_experience
    begin
      first_contract = contracts(:condition => "from_month IS NOT NULL").last
      date = Date.parse("01-#{first_contract.from_month}-#{first_contract.from_year}")
      years = ((Time.now - date.to_time)/60/60/24/365).round(1)
    rescue
      years = 0
    end
    years
  end
  
  def self.find_by_id_or_handle!(id_or_handle)
    begin
      self.find(id_or_handle)
    rescue
      self.find_by_handle!(id_or_handle, :conditions => "handle IS NOT NULL")
    end
  end
  
end
