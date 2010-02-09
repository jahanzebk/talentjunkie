class HelpersController < ApplicationController
  
  def method_missing(method)
    render :template => "/helpers/#{method}", :layout => false
  end
end