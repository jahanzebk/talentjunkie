class JobApplication < ActiveRecord::Base
  belongs_to :applicant, :class_name => "User", :foreign_key => "applicant_id"
  belongs_to :contract
end