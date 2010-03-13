class InvitationsController < ApplicationController
  
  def new
    @html_content = render_to_string :partial => "/invitations/new.haml"
    respond_to do |format|
      format.js { render :template => "/common/new.rjs"}
    end
  end
  
  def create
    addresses = params[:email_addresses].split(",").map {|a| a.strip}.uniq
    
    addresses.each do |address|
      begin
        Notifier.deliver_message_inviting_person(_protocol_domain_and_port, current_user, address)
      end
    end
    
    render :json => {:url => person_path(current_user)}.to_json, :status => 201
  end
  
end