class UsersController < ApplicationController
  include HTTParty
  
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :no_user,        only: [:new, :create]
  before_action :approval_user,  only: :approve
  before_action :appointment_user, only: [:add_clanwar, :remove_clanwar]
  before_action :fetch_user_stats, only: [:index, :show]
  # before_action :build_new_users, only: [:index]
  
  def index
    if params[:type]
      type = params[:type]
      case type
      when 'pending'
        filter = "role = ?"
        value = UserPending
      when 'leadership'
        filter = "role > ?"
        value = UserTreasurer
      when 'clan_war'
        filter = "clan_war_team = ?"
        value = true
      when 'ambassadors'
        filter = "role = ?"
        value = UserAmbassador
      when 'active'
        filter = "active = ?"
        value = true
      end
    end

    if filter
      @users = User.where(filter, value).paginate(page: params[:page], :per_page => 10).order(:wot_name)
    else
      @users = User.paginate(page: params[:page], :per_page => 10).order(:wot_name)
    end
  end

  def show
    @user = User.find(params[:id])
    if (@user.wins)
      @wins = "#{(@user.wins.to_f / @user.battles_count * 100).round(2)}%"
    end
    if (@user.losses)
      @losses = "#{(@user.losses.to_f / @user.battles_count * 100).round(2)}%"
    end
    if (@user.survived)
      @survived = "#{(@user.survived.to_f / @user.battles_count * 100).round(2)}%"
    end
    if (@user.experiance)
      @average_xp = "#{(@user.experiance.to_f / @user.battles_count).round(2)}"
    end
    if (@user.damage_dealt)
      @average_damage = "#{(@user.damage_dealt.to_f / @user.battles_count).round(2)}"
    end
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
        flash[:success] = "Welcome to Fear The Fallen"
        redirect_to @user
       else
         render 'new'
       end
    else
      params[:active] = true
      @user = User.new(params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Fear The Fallen"
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
    :password_confirmation)
  end

  def fetch_user_stats
    if Update.first
      last_update = Update.first.updated_at  
    else
      last_update = DateTime.now
      update = Update.new
      update.save
    end

    if DateTime.now.to_i - last_update.to_i > 3600 && !Rails.env.test?
      # Set the Update Time
      Update.first.touch
      
      Rails.logger.info "About to Start Update Thread"
      Thread.new do
        User.all.each do |user|
          user.update_stats
        end
        ActiveRecord::Base.connection.close
      end
    elsif Rails.env.test?
      User.all.each do |user|
        user.update_stats
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
        clan_id = "1000007730"
        clan_name = "Fear the Fallen"
        url = "http://api.worldoftanks.com/community/clans/#{clan_id}/api/1.1/?source_token=WG-WoT_Assistant-1.3.2"
        response = self.class.get url
        if response.parsed_response.class == Hash
          json_response = response.parsed_response
        else
          json_response = JSON.parse response.parsed_response  
        end
        
        if json_response["status"] == 'ok'
            members = json_response["data"]["members"]
            members.each do |member|
              role = UsersHelper.convert_role(member['role_localised'], clan_name)
              password = User.new_remember_token
              email = "#{member['account_name']}@fearthefallen.com"
              user = User.new(name: "Inactive", 
                              wot_name: member['account_name'], 
                              email: email, 
                              password: password, 
                              password_confirmation: password, 
                              wot_id: member['account_id'],
                              role: role)            
              existing_user = User.find_by(wot_name: member['account_name'])
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
