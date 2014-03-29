class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :no_user,        only: [:new, :create]
  
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
end
