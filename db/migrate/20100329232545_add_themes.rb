class AddThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.string :name
    end
    
    connection.execute("INSERT INTO themes VALUES (1, 'default')")
  end

  def self.down
    drop_table :themes
  end
end
