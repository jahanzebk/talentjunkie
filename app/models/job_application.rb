class JobApplication < ActiveRecord::Base
  belongs_to :applicant, :class_name => "User", :foreign_key => "applicant_id"
  belongs_to :contract
  belongs_to :status, :class_name => "JobApplicationStatus", :foreign_key => "job_application_status_id"
end