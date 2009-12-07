class JobApplication < ActiveRecord::Base
  belongs_to :applicant, :class_name => "User", :foreign_key => "applicant_id"
  belongs_to :contract
  
  belongs_to :phase, :class_name => "JobApplicationPhase", :foreign_key => "job_application_phase_id"
end