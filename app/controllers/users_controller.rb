class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :no_user,        only: [:new, :create]
  before_action :approval_user,  only: :approve
  
  def index
    @users = User.paginate(page: params[:page], :per_page => 10).order(:id)
  end

  def show
    @user = User.find(params[:id])
    @disqus = "user:#{ params[:id] }"
    if current_user && current_user.rank_id > UserPending
      @events = @user.events.paginate(page: params[:page], :per_page => 10)
    else
      @events = @user.events.public.paginate(page: params[:page], :per_page => 10)      
    end        
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Application to Fear the Fallen has been accepted!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update    
    if @user.update_attributes(user_params.merge(:name => @user.name))
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

  def approve
    @user = User.find(params[:id]);
    if @user.update_attribute(:rank_id, UserRecruit)
      UserMailer.approved(@user).deliver
      flash[:success] = "User approved."
      redirect_to request.referer
    else
      flash[:error] = "Unable to approve user."
      redirect_to request.referer
    end
  end

  # PRIVATE METHODS
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :time_zone)
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
      redirect_to root_path if signed_in?
    end
    
    def approval_user
      redirect_to(root_url) unless current_user.rank_id >= UserOfficer
    end
end
