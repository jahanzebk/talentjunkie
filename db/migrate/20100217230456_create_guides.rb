class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides, :id => false do |t|
      t.string :name
      t.string :template
    end
    
    connection.execute("INSERT INTO guides VALUES ('after_signup', 'after_signup')")
  end

  def self.down
    drop_table :guides
  end
end
