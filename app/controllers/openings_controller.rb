class OpeningsController < ApplicationController
  
  def show
    begin
      @contract = Contract.find(params[:id], :conditions => "user_id IS NULL")
      @organization = @contract.position.organization
    rescue
      raise
      render_404
    end
  end
  
end