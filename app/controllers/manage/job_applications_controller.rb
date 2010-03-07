class Manage::JobApplicationsController < ApplicationController

  def index
    @opening = Contract.find(params[:opening_id])
    @organization = @opening.position.organization
    
    @show_all = params[:stage_id].blank?
    @current_stage = JobApplicationStage.find(params[:stage_id]) if params[:stage_id]
    
    @applications = @current_stage ? @opening.applications.all(:conditions => "job_application_stage_id = #{@current_stage.id}") : @opening.applications.all
  end
end