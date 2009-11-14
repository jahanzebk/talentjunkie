class PositionsController < ApplicationController
  
  def index
    @organization = Organization.find(params[:organization_id])
  end
  
  def show
    @organization = Organization.find(params[:organization_id])
    @position = Position.find(params[:id])
  end
end