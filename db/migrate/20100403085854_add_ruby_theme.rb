class AddRubyTheme < ActiveRecord::Migration
  def self.up
    connection.execute("INSERT INTO themes VALUES(2, 'ruby')")
  end

  def self.down
    connection.execute("DELETE FROM themes where id = 2")
  end
end
