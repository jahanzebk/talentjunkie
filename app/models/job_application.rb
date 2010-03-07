class JobApplication < ActiveRecord::Base
  belongs_to :applicant, :class_name => "User", :foreign_key => "applicant_id"
  belongs_to :contract
  belongs_to :stage, :class_name => "JobApplicationStage", :foreign_key => "job_application_stage_id"
end