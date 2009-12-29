class CrunchbasePermalinksController < ApplicationController
  
  def redirect
    begin
      @organization = Organization.find_by_crunchbase_permalink(params[:id])
      redirect_to organization_path(@organization)
    rescue
      raise
    end
  end
end