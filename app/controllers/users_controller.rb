class UsersController < ApplicationController
  
  before_filter :check_authentication, :except => :show
  
  def show
    begin
      current_user.present? ? _profile_with_logged_in_user : _public_profile
    rescue
      raise
      render_404
    end
  end
  
  private
  
  def _public_profile
    @user = User.find_by_id_or_handle!(params[:id])
    @title = "#{@user.full_name}'s Public Profile"
    
    Stats::ProfileView.create!({:user_id => @user.id})
    render :template => "/users/public_profile.haml"
  end
  
  def _profile_with_logged_in_user
    @user = User.find_by_id_or_handle!(params[:id])
    @title = @user.full_name
    
    if current_user == @user
      render :template => "/users/my_profile.haml"
    else
      Stats::ProfileView.create!({:user_id => @user.id, :viewer_id => current_user.id})
      render :template => "/users/show/user/profile.haml"
    end
  end
  
  public
  
  def newsfeed
    @user = User.find(params[:id])
    render :template => "/users/show/user/newsfeed.haml"
  end
  
  def organizations
    @user = current_user
    render :template => "/users/my_organizations.haml"
  end
  
  def settings
    render :template => "/users/my_settings.haml"
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.primary_email = params[:user][:primary_email]
    @user.password = params[:user][:password]

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
  
  def edit
    @user = current_user
    @html_content = render_to_string :partial => "/users/edit.haml"
    respond_to do |format|
      format.js
    end
  end
  
  def update
      begin
        @user = current_user
        @user.first_name = params[:user][:first_name]
        @user.last_name = params[:user][:last_name]
        @user.twitter_handle = params[:user][:twitter_handle]
        @user.save!
        
        @user.detail.summary = params[:user_details][:summary]
        @user.detail.cities_id = params[:user_details][:city][:id]
        @user.detail.save!
      
        render :json => {:url => person_path(current_user)
          }.to_json, :status => 201
      rescue
        render :json => collect_errors_for(@user, @user.detail).to_json, :status => 406
      end
  end

  def follow
    respond_to do |format|
      begin
        @user_to_follow = User.find(params[:id])
        FollowingPerson.create!({:follower_user_id => current_user.id, :followed_user_id => @user_to_follow.id}) unless current_user.is_following?(@user_to_follow)
        
        begin
          Notifier.deliver_message_notifying_someone_started_following_user(current_user, @user_to_follow)
        rescue
          raise
        end

        Events::StartFollowingPeople.create!({:subject_id => current_user.id, :object_id => @user_to_follow.id})
        
        format.json{ render :json => :ok }
      rescue
        format.json{ render :json => {}, :status => 500 }
      end
    end
  end
  
  def unfollow
  end
  
  private
  
  # deprecate
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
  
  #deprecate
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
  
end
