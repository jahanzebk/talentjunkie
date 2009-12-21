class Organization < ActiveRecord::Base

  has_many :degrees

  belongs_to :industry
  has_many :positions
  has_many :contracts, :through => :positions
  
  validates_uniqueness_of :name
  validates_length_of :name, :in => 2..80, :allow_nil => true

  has_many :followed_by_people, :class_name => "User", :finder_sql => 'SELECT users.* FROM following_organizations LEFT JOIN users ON (users.id = following_organizations.user_id) WHERE following_organizations.organization_id = #{id}'
  
end
