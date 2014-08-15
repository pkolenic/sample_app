module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      if (params.has_key?(:clan_id))
        redirect_to main_app.signin_url(:clan_id => params[:clan_id]), notice: "Please sign in"
      else
        redirect_to main_app.signin_url, notice: "Please sign in"
      end
    end
  end
  
  def approved_user
    if signed_in?
      unless current_user.role > UserPending
        flash[:error] = "Your account needs to be approved before you can view Tournaments!"
        redirect_to(root_url)      
      end       
    else
      signed_in_user
    end
  end
  
  def clan_soldier
    if signed_in?
      unless current_user.clan && current_user.role >= UserSoldier
        flash[:error] = "You need to be at least a Soldier in #{current_user.clan.name} to view Tournaments!"
        redirect_to(root_url)      
      end      
    else
      signed_in_user       
    end
  end
  
  def clan_admin(clan)
    if signed_in?
      unless user.has_privilege?(CLAN_ADMIN)
        flash[:error] = "You don't have permission to edit clan content"
        redirect_to_home
      end
      unless user.clan == clan
        flash[:error] = "You don't have permission to edit that clan's content"
        redirect_to_home
      end
    else
      store_location
      redirect_to main_app.signin_url(:clan_id => clan.slug), notice: "Please sign in"     
    end
  end
  
  def redirect_to_home
    unless signed_in?
      redirect_to(main_app.root_url)
    end
    unless current_user.clan
      redirect_to(main_app.root_url)
    end
    redirect_to(main_app.clan_path(current_user.clan))
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
