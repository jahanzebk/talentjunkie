class AddContentToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :content, :string
  end

  def self.down
    remove_column :events, :content
  end
end
