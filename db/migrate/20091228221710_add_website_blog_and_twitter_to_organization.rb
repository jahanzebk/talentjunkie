class AddWebsiteBlogAndTwitterToOrganization < ActiveRecord::Migration
  def self.up
    add_column :organizations, :website, :string
    add_column :organizations, :blog, :string
    add_column :organizations, :twitter_handle, :string
  end

  def self.down
    remove_column :organizations, :twitter_handle
    remove_column :organizations, :blog
    remove_column :organizations, :website
  end
end
