class Manage::JobApplicationsController < ApplicationController

  def index
    @opening = Contract.find(params[:opening_id])
    @organization = @opening.position.organization
  end
  
end