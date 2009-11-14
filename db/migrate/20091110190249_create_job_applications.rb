class CreateJobApplications < ActiveRecord::Migration
  def self.up
    create_table :job_applications do |t|
      t.integer :contract_id
      t.integer :applicant_id
      t.timestamps
    end
  end

  def self.down
    drop_table :job_applications
  end
end
