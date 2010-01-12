class CreateJobApplicationStatus < ActiveRecord::Migration
  def self.up
    create_table :job_application_statuses do |t|
      t.integer :contract_id
      t.string :name
      t.string :label
      t.integer :order
    end
    
    add_column :job_applications, :job_application_status_id, :integer, :null => false
  end

  def self.down
    remove_column :job_applications, :job_application_status_id
    drop_table :job_application_statuses
  end
end
