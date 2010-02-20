class JobApplicationsController < ApplicationController
  
  def create
    @opening = Contract.find(params[:opening_id])
    status = JobApplicationStatus.first({:conditions => "contract_id = #{@opening.id}", :order => "`order` ASC", :limit => 1})
    @job = JobApplication.create!(:contract_id => @opening.id, :applicant_id => current_user.id, :job_application_status_id => status.id)
    redirect_to organization_opening_path(@opening.position.organization, @opening)
  end
end