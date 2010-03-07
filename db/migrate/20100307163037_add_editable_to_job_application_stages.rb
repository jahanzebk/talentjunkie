class AddEditableToJobApplicationStages < ActiveRecord::Migration
  def self.up
    add_column :job_application_stages, :editable, :boolean, :default => false
  end

  def self.down
    remove_column :job_application_stages, :editable
  end
end
