class CreateJobApplicationStages < ActiveRecord::Migration
  def self.up
    create_table :job_application_stages do |t|
      t.integer :contract_id
      t.string :name
      t.string :label
      t.integer :order
    end

    add_column :job_applications, :job_application_stage_id, :integer, :null => false
    
    drop_table :job_application_phases
    drop_table :job_application_statuses
    
    remove_column :job_applications, :job_application_phase_id
    remove_column :job_applications, :job_application_status_id
  end

  def self.down
    remove_column :job_applications, :job_application_stage_id
    drop_table :job_application_stages
  end
end
