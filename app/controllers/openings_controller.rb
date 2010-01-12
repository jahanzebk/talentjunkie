class OpeningsController < ApplicationController
  
  def show
    begin
      @opening = Contract.find(params[:id])
      @organization = @opening.position.organization
    rescue
      raise
      render_404
    end
  end
  
end