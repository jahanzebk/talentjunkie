class User < ActiveRecord::Base
  
  acts_as_authentic do |config|
    config.login_field = :primary_email
    config.require_password_confirmation = false
  end
  
  attr_accessible :primary_email, :password, :first_name, :last_name, :dob
  
  has_many :emails
  has_many :contracts, :order => "contracts.from_year DESC, contracts.from_month DESC, contracts.to_year DESC, contracts.to_month DESC"
  has_many :positions, :through => :contracts
  has_many :postings, :class_name => 'Contract', :foreign_key => 'posted_by_user_id'
  has_many :applications, :class_name => 'JobApplication', :foreign_key => 'applicant_id'
  
  # connections
  # has_many :pending_connections, :class_name => "User", :finder_sql => 'SELECT users.* FROM users LEFT JOIN connection_requests ON(connection_requests.requester_id = users.id OR connection_requests.acceptor_id = users.id) WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND users.id != #{id} AND connection_requests.state = 0'
  has_many :connections, :class_name => "ConnectionRequest", :finder_sql => 'SELECT connection_requests.* FROM connection_requests WHERE connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}'
  has_many :connections_pending,  :class_name => "ConnectionRequest", :finder_sql=> 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state =0'
  has_many :connections_accepted, :class_name => "ConnectionRequest", :conditions => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state = 1'
  has_many :connections_ignored,  :class_name => "ConnectionRequest", :conditions => 'SELECT connection_requests.* FROM connection_requests WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND connection_requests.state = 2'
  
  has_many :network_users, :class_name => "User", :finder_sql => 'SELECT users.* FROM users LEFT JOIN connection_requests ON(connection_requests.requester_id = users.id OR connection_requests.acceptor_id = users.id) WHERE (connection_requests.requester_id = #{id} OR connection_requests.acceptor_id = #{id}) AND users.id != #{id} AND connection_requests.state = 1'
  
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
    organizations.include?(organization)
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
end
