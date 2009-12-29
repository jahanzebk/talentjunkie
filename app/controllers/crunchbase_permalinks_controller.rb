class CrunchbasePermalinksController < ApplicationController
  
  def redirect
    begin
      @organization = Organization.find_by_crunchbase_permalink(params[:id])
      redirect_to organization_path(@organization)
    rescue
      begin
        organization_name = params[:id].gsub(/-/, " ").titleize
        @organization = Organization.create!(:name => organization_name, :crunchbase_permalink => params[:id])
        redirect_to organization_path(@organization)
      rescue
        render_404
      end
    end
  end
end