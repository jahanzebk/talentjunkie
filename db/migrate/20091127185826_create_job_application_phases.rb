class CreateJobApplicationPhases < ActiveRecord::Migration
  def self.up
    create_table :job_application_phases do |t|
      t.string :name
      t.string :label
      t.string :description
    end
    
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('New', 'N', '')")
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('Reviewed', 'R', '')")
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('Shortlisted', 'S', '')")
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('Assessed', 'Ass', '')")
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('Offered', 'O', '')")
    connection.execute("INSERT INTO job_application_phases (name, label, description) VALUES('Appointed', 'Ap', '')")
    
    add_column :job_applications, :job_application_phase_id, :integer, {:default => 1}
  end

  def self.down
    remove_column :job_applications, :job_application_phase_id
    drop_table :job_application_phases
  end
end
