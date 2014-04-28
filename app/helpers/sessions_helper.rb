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
      redirect_to main_app.signin_url, notice: "Please sign in."
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
      unless current_user.role >= UserSoldier
        flash[:error] = "You need to be at least a Soldier in #{CLAN_NAME} to view Tournaments!"
        redirect_to(root_url)      
      end      
    else
      signed_in_user       
    end
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
