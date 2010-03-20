class RemoveDefaultCity < ActiveRecord::Migration
  def self.up
    connection.execute("alter table user_details alter column cities_id drop default")
  end

  def self.down
  end
end
