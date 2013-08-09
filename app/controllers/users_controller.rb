class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :no_user,        only: [:new, :create]
  
  def index
    if params[:type]
      type = params[:type]
      case type
        when 'pending'
          filter = "status = ?" 
          value = 0
        when 'leadership'
          filter = "status > ?"
          value = 1
         when 'clan_war'
           filter = "clan_war_team = ?"
           value = true
      end
    end
    
    if filter
      @users = User.where(filter, value).paginate(page: params[:page], :per_page => 10).order(:id)
    else  
      @users = User.paginate(page: params[:page], :per_page => 10).order(:id)
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Fear The Fallen"
      redirect_to @user
    else
      render 'new'
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
    if @user.update_attribute(:status, 1)
      UserMailer.approved(@user).deliver
      flash[:success] = "User approved."
      redirect_to request.referer
     else
       flash[:error] = "Unable to approve user."
       redirect_to request.referer
     end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :wot_name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
    
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
end
