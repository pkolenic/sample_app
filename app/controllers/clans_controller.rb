class ClansController < ApplicationController
  before_action :proper_access_rights,      only: [:admin]
  
  def show
    @clan = Clan.friendly.find(params[:id])
  end
  
  def admin
    
  end
  
  
  # Before filters
  def proper_access_rights
    @clan = Clan.friendly.find(params[:clan_id])
    if signed_in?
      if current_user.hasPrivilege?(CLAN_ADMIN)
        unless current_user.clan == @clan
          flash[:error] = "You can only visit the admin panel for your clan!"
          redirect_to(clan_url(@clan))              
        end
      else
        flash[:error] = "Only clan admins can visit the admin panel!"
        redirect_to(clan_url(@clan))    
      end      
    else
      signed_in_user
    end
  end
end
