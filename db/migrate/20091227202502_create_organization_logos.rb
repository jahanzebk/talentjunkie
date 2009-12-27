class CreateOrganizationLogos < ActiveRecord::Migration
  def self.up
    create_table :organization_logos do |t|
      t.column :organization_id, :integer
      t.column :filename, :string
      t.column :content_type, :string
      t.column :uploaded_on, :datetime
      t.column :uploaded_by_user_id, :integer
      t.column :description, :string
      t.column :size, :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
    end
  end

  def self.down
    drop_table :organization_logos
  end
end
