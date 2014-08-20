class UsersController < ApplicationController
  include HTTParty
  
  before_action :signed_in_user,        only: [:index, :edit, :update, :destroy]
  before_action :correct_user,          only: [:edit, :update]
  before_action :admin_user,            only: :destroy
  before_action :no_user,               only: [:new, :create]
  before_action :build_new_users,       only: [:index]
  before_action :fetch_all_user_stats,  only: [:index, :show]
  before_action :fetch_user_stats,      only: [:show]
  
 def index
    type = params[:type]
    @clan = Clan.friendly.find(params[:clan_id])
    
    order = 'name'
    case type
      when 'pending'
        # @REDO - need to grab Clan Applications
        filter = "role = ?"
        value = UserPending
      when 'leadership'
        filter = "clan_id = #{@clan.id} AND role > ?"
        value = UserTreasurer
        order ='role DESC, lower(name)'
      when 'clan_war'
        filter = "clan_war_team = ? AND clan_id = '#{@clan.id}'"
        value = true
      when 'registered'
        filter = "active = ? AND clan_id = '#{@clan.id}'"
        value = true
      when 'unregisterd'
        filter = "active = ? AND clan_id = '#{@clan.id}'"
        value = false  
      when 'inactive'
        filter = "clan_id = ? AND last_online < '#{Time.now - 30.days}'"
        value = "#{@clan.id}"
      when 'ambassadors'
        filter = "clan_id IS NULL"
        value = nil
      else
        filter = "clan_id = ?"
        value = @clan.id
    end    
    
    @users = User.where(filter, value).paginate(page: params[:page], :per_page => 10).order(order)
    @disqus = "battleroster" 
    
    render layout: "clans"
  end

  def show    
    #@user = User.friendly.find(params[:id])
    @disqus = "user:#{ params[:id] }"
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: "clans"
    end    
  end

  def new
    @user = User.new
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: "clans"
    end       
  end

  def create
    params = new_user_params    
    if params[:name]
      name = params[:name].parameterize
    else
      name = nil
    end
    
    @user = User.find_by(slug: name)
    # Current User applying to a Clan
    if current_user
      if params.has_key?(:clan_id)
        clan = Clan.friendly.find(params[:clan_id])    
        create_user_application(current_user, clan)            
        flash[:success] = "Your application to #{clan.name} is pending"
        UserMailer.applied_to_clan(current_user, clan).deliver
        if current_user.clan
          redirect_to clan_user_path(current_user.clan, current_user)          
        else          
          redirect_to current_user
        end
      else
        # @TODO This case shouldn't exist
        if user.clan
          params[:clan_id] = user.clan.slug
          render 'new', layout: 'clans'
        else
          render 'new'
        end
      end
    # Activating an auto generated user
    elsif @user      
      params[:active] = true
      
      # Grab clan applying to      
      if params.has_key?(:clan_id)
        clan = Clan.friendly.find(params[:clan_id])
        params[:clan_id] = @user.clan_id
      else
        clan = nil
      end
      
      if @user.update_attributes(params)        
        sign_in @user        
        if clan          
          if @user.clan != clan
            create_user_application(@user, clan)            
            UserMailer.user_activated_account_apply_to_clan(@user,clan).deliver
            flash[:success] = "Welcome to #{@user.clan.name}, your application to #{clan.name} is pending"    
          else
            UserMailer.user_activated_account(@user).deliver
            flash[:success] = "Welcome to #{@user.clan.name}"                    
          end
        else
          UserMailer.user_activated_account(@user).deliver
          flash[:success] = "Welcome to #{@user.clan.name}"
        end                
        redirect_to clan_user_path(@user.clan, @user)
       else
         if params.has_key?(:clan_id)
           render 'new', layout: 'clans'
         else
           render 'new'
         end
       end
       
    # New User 
    else
      params[:active] = true
      if params.has_key?(:clan_id) && params[:clan_id] != ''          
        @clan = Clan.friendly.find(params[:clan_id])
      else
        @clan = nil            
      end    
      params = params.except(:clan_id)  
      
      @user = User.new(params)
      if @user.save
        sign_in @user
        # Create Application if user applied to a clan
        if @clan
          create_user_application(@user, @clan)
          UserMailer.applied_to_clan(@user, @clan).deliver
          flash[:success] = "Your application to #{@clan.name} is pending"
        else
          UserMailer.joined_alliance(@user).deliver
          flash[:success] = "Welcome to #{ALLIANCE_NAME}"
        end                                        
        redirect_to @user
      else
        if @clan
          render 'new', layout: "clans"
        else
          render 'new'
        end
      end   
    end   
  end

  def edit
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: 'clans'
    end         
  end

  def update    
    if @user.update_attributes(edit_user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      
      if (@user.clan)
        redirect_to clan_user_path(@user.clan.slug, @user.slug)
      else
        redirect_to @user
      end 
    else      
      if (@user.clan)
        @clan = @user.clan
        render 'edit', layout: 'clans'
      else 
        render 'edit'
      end
    end
  end

  def destroy
    # Save clan for redirecting
    clan = User.friendly.find(params[:id]).clan    
    User.friendly.find(params[:id]).destroy
    flash[:success] = "User destroyed."

    # redirect based on link or destory
    if request.referer
      redirect_to request.referer
    elsif clan
      redirect_to clan_users_path(clan)
    else
      redirect_to root_url
    end    
  end

  def add_clanwar
    @user = User.friendly.find(params[:id])
    
    if !current_user || !@user.clan || current_user.clan != @user.clan || current_user.role < UserDeputyCommander
      flash[:error] = 'You do not have permission to appoint clanwar members for this clan!'
    elsif @user.toggle!(:clan_war_team)
      UserMailer.clanwar_added(@user).deliver
      flash[:success] = "#{@user.name} has been appointed to the clan war team"
    else
      flash[:error] = "Unable to add #{@user.name} to the clanwar team."      
    end
    
    # redirect based on link or patch
    if request.referer
      redirect_to request.referer
    elsif @user.clan
      redirect_to clan_users_path(@user.clan)
    else
      redirect_to root_url
    end
  end

  def remove_clanwar
    @user = User.friendly.find(params[:id])
    
    if !current_user || !@user.clan || current_user.clan != @user.clan || current_user.role < UserDeputyCommander
      flash[:error] = 'You do not have permission to remove clanwar members for this clan!'
    elsif @user.toggle!(:clan_war_team)
      UserMailer.clanwar_added(@user).deliver
      flash[:success] = "#{@user.name} has been removed from the clan war team"
    else
      flash[:error] = "Unable to  remove #{@user.name} from the clanwar team."      
    end
    
    # redirect based on link or patch
    if request.referer
      redirect_to request.referer
    elsif @user.clan
      redirect_to clan_users_path(@user.clan)
    else
      redirect_to root_url
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
    params = edit_user_params
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
  def new_user_params
    params.require(:user).permit(:name, :clan_id, :email, :password, :password_confirmation, :time_zone)
  end
  
  def edit_user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :time_zone)
  end
  
  def clan_params
    params.require(:user).permit(:clan_id)
  end

  def fetch_user_stats
    @user = User.friendly.find(params[:id])
    if Rails.env.test?
      # @user.update_stats
    else
      # Thread.new do       
        @user.update_stats
        ActiveRecord::Base.connection.close
      # end
    end
  end

  def create_user_application(user, clan)
    # First get all applications for the user
    applications = Application.where("user_id = ?", user.id).load
    
    # Loop through each and send user email about application deletion
    applications.each do |application|
      UserMailer.application_deleted(application).deliver
      application.destroy
    end
    
    # Now create the New Application
    Application.new(user_id: user.id, clan_id: clan.id).save!    
  end

  def fetch_all_user_stats 
    if Update.find_by(id: USERS_UPDATE)
      last_update = Update.find(USERS_UPDATE).updated_at        
    else
      last_update = DateTime.now
      update = Update.new(id: USERS_UPDATE)
      update.save
    end

    if DateTime.now.to_i - last_update.to_i > 3600 && !Rails.env.test?
      #Set the Update Time
      Update.find(USERS_UPDATE).touch
      
      Rails.logger.info "About to Start Update Thread"
      Thread.new do
        User.all.each do |user|
          user.update_stats
        end
        ActiveRecord::Base.connection.close
        Rails.logger.info "Finished Updating"
      end
    end
  end

  def build_new_users
    if Update.find_by(id: USERS_CREATE)
      last_update = Update.find(USERS_CREATE).updated_at  
    else
      last_update = DateTime.now
      update = Update.new(id: USERS_CREATE)
      update.save
    end
    
    if DateTime.now.to_i - last_update.to_i > (3600 * 12) && !Rails.env.test?
      Update.find(USERS_CREATE).touch
      
      Clan.all.each do |clan|
        Thread.new do
          url = "https://api.worldoftanks.com/wot/clan/info/?application_id=#{ENV['WOT_API_KEY']}&clan_id=#{clan.wot_clanId}"
          json_response = clean_response(self.class.get url);
          
          if json_response['status'] == 'ok'
            members = json_response['data']["#{clan.wot_clanId}"]["members"]         
            members.each do |member|
              data = member[1]
              password = User.new_remember_token
              email = "#{data['account_name']}@#{clan.slug}.com"
              role = UsersHelper.convert_role(data['role'])
              user = User.new(name: data['account_name'],
                              clan_id: clan.id,
                              email: email,
                              password: password,
                              password_confirmation: password,
                              wot_id: data['account_id'],
                              role: role,
                              time_zone: 'Pacific Time (US & Canada)')
              existing_user = User.find_by(name: data['account_name'])
              if !existing_user
                user.save!
              end
            end  
          end
          
          ActiveRecord::Base.connection.close
       end
      end
    end
  end

  def clean_response(response)
    if response.parsed_response.class == Hash
      json_response = response.parsed_response
    else
      json_response = JSON.parse response.parsed_response  
    end
    json_response
  end

  # Before filters
  def correct_user
    @user = User.friendly.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def no_user
    # Find if going to a Clan Signup Page
    if params.has_key?(:clan_id)
      clan = Clan.friendly.find(params[:clan_id])
    else
      clan = nil
    end
    
    if signed_in?
      if clan
        if current_user.clan && current_user.clan == clan
          flash[:error] = 'You already belong to this clan'
          redirect_to(clan_url(current_user.clan))
        end 
      else
          if current_user.clan
            flash[:error] = 'You already belong to a clan, visit another clan\'s page to apply to their clan'
            redirect_to(clan_url(current_user.clan))
          else
            flash[:error] = 'You already have an account, visit a clan page if you would like to join a clan'
            redirect_to(root_url)
          end
      end  
    end
  end
end
