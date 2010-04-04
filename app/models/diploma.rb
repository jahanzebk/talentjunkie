class Diploma < ActiveRecord::Base
  
  belongs_to :degree
  belongs_to :user
  
  validates_presence_of :user, :degree, :from

  accepts_nested_attributes_for :degree

  def from=(attributes)
    attributes = attributes.stringify_keys
    
    if attributes['start_asap']
      self['from'] = DateTime.today.utc
    elsif attributes['month'] and attributes['year']
      self['from'] = DateTime.parse("#{attributes['year']}-#{attributes['month']}-01")
    else
      self['from'] = nil
    end
  end
  
  def to=(attributes)
    attributes = attributes.stringify_keys
    
    if attributes['month'] and attributes['year'] and !attributes['open_ended']
      self['to'] = DateTime.parse("#{attributes['year']}-#{attributes['month']}-01")
    else
      self['to'] = nil
    end
  end
end