class AddSubjectAndObjectTypeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :subject_type, :string, :default => "User"
    add_column :events, :object_type, :string, :default => "User"
  end

  def self.down
    remove_column :events, :object_type
    remove_column :events, :subject_type
  end
end
