class ConnectionRequest < ActiveRecord::Base
  
  belongs_to :acceptor, :class_name => "User"
  belongs_to :requester, :class_name => "User"
  
  include SSM
  
  ssm_inject_state_into :state, :as_integer => true, :strategy => :active_record

  ssm_initial_state :pending
  ssm_state :accepted
  ssm_state :ignored
  
  ssm_event :accept, :from => [:pending, :ignored], :to => :accepted do
    save
  end
  
  ssm_event :ignore, :from => [:pending], :to => :ignored do
    save
  end
  
  def self.exists_for?(u1, u2)
    connection.select_value("SELECT COUNT(*) FROM connection_requests WHERE (connection_requests.requester_id = #{u1.id} AND connection_requests.acceptor_id = #{u2.id}) OR (connection_requests.requester_id = #{u2.id} AND connection_requests.acceptor_id = #{u1.id})").to_i > 0
  end
  
  def self.pending_for?(u1, u2)
    connection.select_value("SELECT COUNT(*) FROM connection_requests WHERE ((connection_requests.requester_id = #{u1.id} AND connection_requests.acceptor_id = #{u2.id}) OR (connection_requests.requester_id = #{u2.id} AND connection_requests.acceptor_id = #{u1.id})) AND state = 0").to_i > 0
  end
  
  def other_user(user)
    if self[:requester_id] == user.id
      User.find(self[:acceptor_id])
    elsif self[:acceptor_id] == user.id
      User.find(self[:requester_id])
    else
      nil
    end
  end
end