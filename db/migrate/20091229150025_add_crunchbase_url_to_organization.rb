class AddCrunchbaseUrlToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :crunchbase_url, :string
  end

  def self.down
    remove_column :organizations, :crunchbase_url
  end
end
