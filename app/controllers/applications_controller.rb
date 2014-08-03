class ApplicationsController < ApplicationController
  
  before_action :clan_approver,  only: :destroy
   
  def index
    @clan = Clan.friendly.find(params[:clan_id])
    order = 'user_id'
    
    @applications = Application.where('clan_id = ?', @clan.id).paginate(page: params[:page], :per_page => 10).order(order)
    @disqus = "battleroster" 
    
    render layout: "clans"
  end
  
  def destroy
    @user = @application.user
    @clan = @application.clan
    if @application.destroy
      ApplicationMailer.rejected_application(@user, @clan).deliver
      flash[:success] = "Application for #{@user.name} has been deleted"      
    else
      flash[:error] = "Unable to reject application."
    end
    
    redirect_to clan_applications_path(@clan)    
  end
  
  private
  # Before filters
  def clan_approver
    @application = Application.find(params[:id])
    
    if !current_user
      flash[:error] = 'You do not have permission to reject an application!'
      redirect_to(root_url)
    elsif current_user.role < UserRecruiter
       flash[:error] = 'You do not have permission to reject an application!'
       if current_user.clan
         redirect_to(clan_url(current_user.clan))
       else
         redirect_to(root_url)
       end
    elsif current_user.clan != @application.clan
       flash[:error] = 'You do not have permission to reject an application from that clan'
       if current_user.clan
        redirect_to(clan_url(current_user.clan))
       else
        redirect_to(root_url)
       end     
    end    
  end
end