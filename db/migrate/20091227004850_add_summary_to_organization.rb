class AddSummaryToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :summary, :text
    remove_column :organizations, :description
  end

  def self.down
    add_column :organizations, :description, :string
    remove_column :organizations, :summary
  end
end
