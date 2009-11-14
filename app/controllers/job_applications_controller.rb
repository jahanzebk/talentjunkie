class JobApplicationsController < ApplicationController
  
  def create
    @contract = Contract.find(params[:contract_id])
    @job = JobApplication.new(:contract_id => @contract.id, :applicant_id => current_user.id)
    @job.save!
    redirect_to organization_position_path(@contract.position.organization, @contract.position)
  end
  
end