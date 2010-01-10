class JobApplicationsController < ApplicationController

  def index
    @contract = Contract.find(params[:opening_id])
    @organization = @contract.position.organization
  end
  
  def create
    @contract = Contract.find(params[:opening_id])
    @job = JobApplication.create!(:contract_id => @contract.id, :applicant_id => current_user.id)
    redirect_to organization_opening_path(@contract.position.organization, @contract)
  end
  
end