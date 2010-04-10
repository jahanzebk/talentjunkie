class SignupFbController < PublicController

  skip_before_filter :redirect_if_session_exists
  
  def new
    @fb_config = YAML::load(File.open("#{RAILS_ROOT}/config/facebooker.yml"))
    @fb_api_key = @fb_config[RAILS_ENV]["api_key"]
    @fb_secret_key = @fb_config[RAILS_ENV]["secret_key"]

    fb_uid = request.cookies["#{@fb_api_key}_user"]
    fb_session_key = request.cookies["#{@fb_api_key}_session_key"]
    
    @fb_client = FacebookApiCore::Client.new(@fb_api_key, @fb_secret_key)
    @fb_info = @fb_client.users.getInfo([fb_uid], fb_session_key)
    
    @user = User.new
    @user.first_name = @fb_info.body.at_xpath("//fb:first_name", {"fb" => "http://api.facebook.com/1.0/"}).content
    @user.last_name  = @fb_info.body.at_xpath("//fb:last_name", {"fb" => "http://api.facebook.com/1.0/"}).content
  end
  
  def create
    fb_uid = request.cookies["#{@fb_api_key}_user"]
    fb_session_key = request.cookies["#{@fb_api_key}_session_key"]
    
    @user = FbUser.new
    @user.first_name = params[:fb_user][:first_name]
    @user.last_name = params[:fb_user][:last_name]
    @user.primary_email = params[:fb_user][:primary_email]
    @user.facebook_uid = fb_uid
    
    @user.detail = UserDetail.create!
    @user.settings = UserSetting.create!
    begin
      @user.save!
      @user.steps << AchievementStep.find(1)
      
      queue_guide_by_name(:after_signup)
      
      begin
        Notifier.deliver_message_new_signup(_protocol_domain_and_port, @user, 'luis.ca@gmail.com')
      end
      
      session[:user] = @user.id
      render :json => {:url => person_path(@user)}.to_json, :status => 201
    rescue
      render :json => collect_errors_for(@user).to_json, :status => 406
    end
  end
  
end
