class Organization < ActiveRecord::Base

  belongs_to :industry
  has_many :positions
  has_many :degrees
  has_many :contracts, :through => :positions
  
  validates_uniqueness_of :name
  validates_length_of :name, :in => 2..80, :allow_nil => true
  
  # has_many :associates (persons)
end
