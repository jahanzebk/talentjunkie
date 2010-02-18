class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides, :id => false do |t|
      t.string :name
      t.string :template
    end
  end

  def self.down
    drop_table :guides
  end
end
