class CreateConnectionRequests < ActiveRecord::Migration
  def self.up
    create_table :connection_requests do |t|
      t.integer  :state, :default => 0
      t.integer  :requester_id
      t.integer  :acceptor_id
      t.datetime :requested_at
      t.datetime :accepted_at
    end
  end

  def self.down
    drop_table :connection_requests
  end
end
