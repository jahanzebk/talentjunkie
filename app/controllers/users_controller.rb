class UsersController < ApplicationController

  def profile
    @user = params[:id] ? User.find(params[:id]) : current_user
    @title = @user.full_name
    
    if @user == current_user
      render :template => "/users/my_profile.haml"
    else
      render :template => "/users/public_profile.haml"
    end
  end

  def newsfeed
    @user = current_user
    render :template => "/users/my_newsfeed.haml"
  end

  def organizations
    @user = current_user
    render :template => "/users/my_organizations.haml"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        # format.xml  { render :xml => @user, :status => :created, :location => @users }
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def request_connection
    respond_to do |format|
      begin
        @user = User.find(params[:id])
        ConnectionRequest.create!({:requester_id => current_user.id, :acceptor_id => @user.id, :requested_at => Time.now.utc}) unless ConnectionRequest.exists_for?(@user, current_user)        
        format.json{ render :json => :ok }
      rescue
        format.json{ render :json => {}, :status => 500 }
      end
    end    
  end

  def accept_connection
    respond_to do |format|
      begin
        @connection_request = ConnectionRequest.find(params[:connection_id])
        @connection_request.accept
        format.json{ render :json => :ok }
      rescue
        format.json{ render :json => {}, :status => 500 }
      end
    end    
  end
  
  def edit
    @user = current_user
    @html_content = render_to_string :partial => "/users/edit.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @user = current_user
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.save!
    @user.detail.summary = params[:user_details][:summary]
    @user.detail.save!
    redirect_to :my_profile
  end
  
end
