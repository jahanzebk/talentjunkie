class SignupController < ApplicationController
  
  skip_before_filter :check_authentication
  
  def create
    ActiveRecord::Base.transaction do
      @user = SimpleUser.new
      @user.first_name = params[:simple_user][:first_name]
      @user.last_name = params[:simple_user][:last_name]
      @user.primary_email = params[:simple_user][:primary_email]
      @user.password = params[:simple_user][:password]

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
  
end