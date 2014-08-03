class SessionsController < ApplicationController
  
  def new
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: "clans"
    end
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && !user.active?
      flash[:error] = 'User not active, setup account to activate'
      if user.clan
        redirect_to signup_url(:clan_id => user.clan.slug)
      else
        redirect_to signup_url
      end              
    elsif user && user.authenticate(params[:password])
      sign_in user
      if (user.clan)
        redirect_back_or clan_user_path(user.clan.slug, user.slug)
      else
        redirect_back_or user
      end        
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # store the clan info if the user is in a clan
    if current_user && current_user.clan
      clan = current_user.clan        
    end
    
    # signout the the user
    sign_out
    
    # redirect based on if user was in a clan
    if (clan)
      redirect_to clan
    else
      redirect_to root_url 
    end    
  end
end
