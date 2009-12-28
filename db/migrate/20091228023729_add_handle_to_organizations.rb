class AddHandleToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :handle, :string
  end

  def self.down
    remove_column :organizations, :handle
  end
end
