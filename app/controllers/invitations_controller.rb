class InvitationsController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/invitations/new.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def create
    addresses = params[:email_addresses].split(",").map {|a| a.strip}.uniq
    
    addresses.each do |address|
      begin
        Notifier.deliver_message_inviting_person(current_user, address)
      end
    end
    
    render :json => {:url => person_path(current_user)}.to_json, :status => 201
  end
  
end