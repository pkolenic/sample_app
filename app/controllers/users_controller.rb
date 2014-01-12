class UsersController < ApplicationController
  include HTTParty
  
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :no_user,        only: [:new, :create]
  before_action :approval_user,  only: :approve
  before_action :appointment_user, only: [:add_clanwar, :remove_clanwar]
  before_action :build_new_users, only: [:index]
  before_action :fetch_all_user_stats, only: [:index, :show]
  before_action :fetch_user_stats, only: [:show]
 def index
    type = params[:type]
    order = 'wot_name'
    case type
      when 'pending'
        filter = "role = ?"
        value = UserPending
      when 'leadership'
        filter = "role > ?"
        value = UserTreasurer
        order ='role DESC, lower(wot_name)'
      when 'clan_war'
        filter = "clan_war_team = ?"
        value = true
      when 'ambassadors'
        filter = "role = ?"
        value = UserAmbassador
      when 'active'
        filter = "active = ? AND clan_id = '#{CLAN_ID}'"
        value = true
      when 'inactive'
        filter = "clan_id = ? AND last_online < '#{Time.now - 30.days}'"
        value = "#{CLAN_ID}"
      else
        filter = "clan_id = ?"
        value = CLAN_ID
    end

    @users = User.where(filter, value).paginate(page: params[:page], :per_page => 10).order(order)
    @disqus = "battleroster" 
  end

  def show    
    @disqus = "user:#{ params[:id] }"
  end

  def new
    @user = User.new
  end

  def create
    params = user_params
    @user = User.find_by(wot_name: params[:wot_name])
    if @user && !@user.active?
      params[:active] = true
      if @user.update_attributes(params)
        UserMailer.approved(@user).deliver
        sign_in @user
        flash[:success] = "Welcome to #{CLAN_NAME}"
        redirect_to @user
       else
         render 'new'
       end
    else
      params[:active] = true
      @user = User.new(params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to #{CLAN_NAME}"
        redirect_to @user
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def approve
    @user = User.find(params[:id]);
    if @user.update_attribute(:role, UserRecruit)
      UserMailer.approved(@user).deliver
      flash[:success] = "User approved."
      redirect_to request.referer
    else
      flash[:error] = "Unable to approve user."
      redirect_to request.referer
    end
  end

  def add_clanwar
    @user = User.find(params[:id]);
    if @user.toggle!(:clan_war_team)
      UserMailer.clanwar_added(@user).deliver
      flash[:success] = "User added to clanwar team."
      redirect_to request.referer
    else
      flash[:error] = "Unable to add user to clanwar team."
      redirect_to request.referer
    end
  end

  def remove_clanwar
    @user = User.find(params[:id]);
    if @user.toggle!(:clan_war_team)
      UserMailer.clanwar_removed(@user).deliver
      flash[:success] = "User removed from clanwar team."
      redirect_to request.referer
    else
      flash[:error] = "Unable to add user to clanwar team."
      redirect_to request.referer
    end
  end

  def reset_password
    reset_token = User.encrypt(params[:token])
    @user = User.find_by(reset_token: reset_token)
    @token = params[:token]
    if !@user
      flash[:error] = "Invalid reset token!"
      redirect_to(root_url)
    elsif @user.reset_expire < DateTime.now
      flash[:error] = "The Reset Token has expired, please request a new one!"
      redirect_to(root_url)
    end
  end

  def update_password
    reset_token = User.encrypt(params[:token])
    @user = User.find_by(reset_token: reset_token)
    @token = params[:token]
    params = user_params
    params[:reset_token] = nil
    params[:reset_expire] = nil
    if @user.update_attributes(params)
      flash[:success] = "Password Reset"
      UserMailer.password_reset(@user).deliver
      sign_in @user
      redirect_to @user
    else
      render 'reset_password'
    end
  end

  def request_password  
      @user = User.new
  end

  def send_reset_request
    user = User.find_by(email: params[:email].downcase)
    token = User.new_remember_token;
    expire = 6.hours.from_now;
    if !user 
      flash[:error] = "No account found for that email address!"
    else
      if !user.update_attribute(:reset_expire, expire) || !user.update_attribute(:reset_token, User.encrypt(token))
        flash[:error] = "Unable to generate reset"
      else
        UserMailer.request_password_reset(user, token).deliver
        flash[:info] = "Password Reset Email Sent"      
      end      
    end
    redirect_to(root_url)
  end
  

  private
  def user_params
    params.require(:user).permit(:name, :wot_name, :email, :password,
    :password_confirmation, :time_zone)
  end

  def fetch_user_stats
    @user = User.find(params[:id])
    if Rails.env.test?
      @user.update_stats
    else
      Thread.new do     
        @user.update_stats
        ActiveRecord::Base.connection.close
      end
    end
  end

  def fetch_all_user_stats 
    if Update.first
      last_update = Update.first.updated_at  
    else
      last_update = DateTime.now
      update = Update.new
      update.save
    end

    Rails.logger.info "Need to do update = #{ (DateTime.now.to_i - last_update.to_i > 3600)}"
    if DateTime.now.to_i - last_update.to_i > 3600 && !Rails.env.test?
      #Set the Update Time
      Update.first.touch
      
      Rails.logger.info "About to Start Update Thread"
      Thread.new do
        User.all.each do |user|
          user.update_stats
        end
        ActiveRecord::Base.connection.close
      end
    end
  end

  def build_new_users
    if Update.first
      last_update = Update.first.updated_at  
    else
      last_update = DateTime.now
      update = Update.new
      update.save
    end
    
    if DateTime.now.to_i - last_update.to_i > (3600 * 12) && !Rails.env.test?
      Update.first.touch
      Thread.new do
        url = "https://api.worldoftanks.com/wot/clan/info/?application_id=#{ENV['WOT_API_KEY']}&clan_id=#{CLAN_ID}"               
        
        # TODO - Create a Help Function to clean Response that All can use
        response = self.class.get url
        if response.parsed_response.class == Hash
          json_response = response.parsed_response
        else
          json_response = JSON.parse response.parsed_response  
        end
        
        if json_response["status"] == 'ok'                               
            members = json_response['data']["#{CLAN_ID}"]["members"]
            members.each do |member|
              data = member[1]
              role = UsersHelper.convert_role(data['role'], CLAN_NAME)
              password = User.new_remember_token
              email = "#{data['account_name']}@{CLAN_GENERIC_EMAIL_SUFFIX}"
              user = User.new(name: "Inactive", 
                              wot_name: data['account_name'], 
                              email: email, 
                              password: password, 
                              password_confirmation: password, 
                              wot_id: data['account_id'],
                              role: role,
                              time_zone: 'Pacific Time (US & Canada)')            
              existing_user = User.find_by(wot_name: data['account_name'])
              if !existing_user
                user.save!
              end
            end
        end
        ActiveRecord::Base.connection.close
      end
    end
  end

  # Before filters
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def no_user
    redirect_to(root_url) if signed_in?
  end

  def approval_user
    redirect_to(root_url) unless current_user.role >= UserRecruiter
  end

  def appointment_user
    redirect_to(root_url) unless current_user.role >= UserDeputyCommander
  end
end
