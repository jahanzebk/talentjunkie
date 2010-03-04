class UsersController < ApplicationController
  
  before_filter :check_authentication, :except => :show
  
  def openings
    @user = current_user
    begin
      @current_organization = Organization.find_by_id_or_handle!(params[:id])
    rescue
      @current_organization = @user.organizations_active.first
    end
    
    views = @user.service.profile_views_by_day_for_the_last_30_days
    @views_data_for_sparkline = views.map {|e| e["views"].to_i}
    render :template => "/users/show/my/openings.haml"
  end
  
  def dashboard
    @user = current_user
  end
  
  def profile_stats
    @user = current_user
    @html_content = render_to_string :partial => "/users/show/my/profile_stats.haml"
    respond_to do |format|
      format.html { render :template => "/users/show/my/_profile_stats.haml"}
      format.js { render :template => "/users/show/my/profile_stats.rjs"}
    end
  end
  
  def show
    begin
      @user = User.find_by_id_or_handle!(params[:id])
      if current_user.present?
        if current_user == @user
          @title = @user.full_name
          views = @user.service.profile_views_by_day_for_the_last_30_days
          @views_data_for_sparkline = views.map {|e| e["views"].to_i}
          render :template => "/users/show/my/profile.haml"
        else
          @title = @user.full_name
          Stats::ProfileView.create!({:user_id => @user.id, :viewer_id => current_user.id})
          render :template => "/users/show/user/profile.haml"
        end
      else
        @title = "#{@user.full_name}'s Public Profile"
        Stats::ProfileView.create!({:user_id => @user.id})
        render :template => "/users/show/public/profile.haml"
      end
    rescue
      raise
      render_404
    end
  end
  
  def newsfeed
    begin
      @user = User.find_by_id_or_handle!(params[:id])
      if current_user.present?
        if current_user == @user
          @title = "#{@user.full_name}'s Newsfeed"
          views = @user.service.profile_views_by_day_for_the_last_30_days
          @views_data_for_sparkline = views.map {|e| e["views"].to_i}
          render :template => "/users/show/my/newsfeed.haml"
        else
          @title = "#{@user.full_name}'s Newsfeed"
          Stats::ProfileView.create!({:user_id => @user.id, :viewer_id => current_user.id})
          render :template => "/users/show/user/newsfeed.haml"
        end
      else
        # not available
      end
    rescue
      raise
      render_404
    end
  end
  
  def organizations
    begin
      @user = User.find_by_id_or_handle!(params[:id])
      if current_user.present?
        if current_user == @user
          @title = "#{@user.full_name}'s Organizations"
          views = @user.service.profile_views_by_day_for_the_last_30_days
          @views_data_for_sparkline = views.map {|e| e["views"].to_i}
          render :template => "/users/show/my/organizations.haml"
        else
          @title = "#{@user.full_name}'s Organizations"
          # Stats::ProfileView.create!({:user_id => @user.id, :viewer_id => current_user.id})
          render :template => "/users/show/user/organizations.haml"
        end
      else
        # not available
      end
    rescue
      raise
      render_404
    end
  end
  
  def settings
    @user = current_user
    views = @user.service.profile_views_by_day_for_the_last_30_days
    @views_data_for_sparkline = views.map {|e| e["views"].to_i}
    render :template => "/users/show/my/settings.haml"
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
        
        step = AchievementStep.find(4)
        current_user.steps << step unless current_user.detail.summary.empty? or current_user.steps.include?(step)
      
        Events::UpdatedProfile.create!({:subject_id => current_user.id})
      
        render :json => {:url => person_path(current_user)}.to_json, :status => 201
      rescue
        raise
        render :json => collect_errors_for(@user, @user.detail).to_json, :status => 406
      end
  end

  def follow
    respond_to do |format|
      begin
        @user_to_follow = User.find(params[:id])
        FollowingPerson.create!({:follower_user_id => current_user.id, :followed_user_id => @user_to_follow.id}) unless current_user.is_following?(@user_to_follow)
        
        begin
          Notifier.deliver_message_notifying_someone_started_following_user(_protocol_domain_and_port, current_user, @user_to_follow)
        rescue
          # raise
        end

        Events::StartFollowingPeople.create!({:subject_id => current_user.id, :object_id => @user_to_follow.id})
        
        step = AchievementStep.find(5)
        current_user.steps << step unless current_user.following_people(true).size < 5 or current_user.steps.include?(step)
        
        format.json{ render :json => :ok }
      rescue
        # raise
        format.json{ render :json => {}, :status => 500 }
      end
    end
  end
  
  def unfollow
  end

  def enable_recruit_mode
    current_user.settings.update_attribute(:recruit_mode, 1)
    
    redirect_to my_profile_path
  end
  
  def disable_recruit_mode
    current_user.settings.update_attribute(:recruit_mode, 0)
    redirect_to my_profile_path
  end
  
  def new_email_profile
    @html_content = render_to_string :partial => "/users/email/new.haml"
    respond_to do |format|
      format.js { render :template => "/users/email/new.rjs" }
    end
  end
  
  def send_email_profile
    addresses = params[:email_addresses].split(",").map {|a| a.strip}.uniq
    addresses.each do |address|
      begin
        Notifier.deliver_message_with_person_profile(_protocol_domain_and_port, current_user, address)
      end
    end
    
    render :json => {:url => person_path(current_user)}.to_json, :status => 201
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
