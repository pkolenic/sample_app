class VideosController < ApplicationController
  before_action :proper_access_rights,      only: [:show]
  before_action :clan_admin_rights,         only: [:index, :new, :edit]
  before_action :delete_rights,             only: [:destroy]
  before_action :edit_rights,               only: [:update]
   
  def index
    order = 'title'
    @videos = Video.where('clan_id = ?', @clan.id).paginate(page: params[:page], :per_page => 20).order(order)
    render layout: "clans"
  end
  
  def new
    @video = Video.new
    @clan = Clan.friendly.find(params[:clan_id])
    render layout: "clans"      
  end
  
  def create
    @video = buffalo
  end
  
  def edit
    @video = Video.friendly.find(params[:id])
    @clan = Clan.friendly.find(params[:clan_id])
    render layout: "clans"     
  end
  
  def update
    
  end
  
  def show
    # Parse Video List (Should be safe not to wrap in Begin Rescue)
    if @video.video_list
      @video.video_list = JSON.parse(@video.video_list)
    end
    
    # Parse Filters (Should be safe not to wrap in Begin Rescue)
    if @video.filters
      @video.filters = JSON.parse(@video.filters)
    end
    
    # Load Clan
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: "clans"
    end    
  end

  def destroy
    # Save clan for redirecting 
    Video.friendly.find(params[:id]).destroy
    flash[:success] = "Video Page has been deleted"

    # redirect based on link or destory
    if request.referer
      redirect_to request.referer
    elsif @clan
      redirect_to clan_path(@clan)
    else
      redirect_to root_url
    end    
  end
    
  private
  
  # Before filters
  def clan_admin_rights
    @clan = Clan.friendly.find(params[:clan_id])
    if signed_in?
      if current_user.hasPrivilege?(CLAN_ADMIN)
        unless current_user.clan == @clan
          flash[:error] = "You can only visit the admin pages for your clan!"
          redirect_to(clan_url(@clan))              
        end
      else
        flash[:error] = "Only clan admins can visit this page!"
        redirect_to(clan_url(@clan))    
      end      
    else
      signed_in_user
    end    
  end
  
  def delete_rights
    @clan = Clan.friendly.find(params[:clan_id])
    if signed_in?
      if current_user.hasPrivilege?(CLAN_ADMIN)
        unless current_user.clan == @clan
          flash[:error] = "You do not have permission to delete video pages from another clan"
          redirect_to(clan_url(@clan))              
        end
      else
        flash[:error] = "You do not have permission to delete video pages"
        redirect_to(clan_url(@clan))    
      end      
    else
      signed_in_user
    end      
  end

  def edit_rights
    @clan = Clan.friendly.find(params[:clan_id])
    if signed_in?
      if current_user.hasPrivilege?(CLAN_ADMIN)
        unless current_user.clan == @clan
          flash[:error] = "You do not have permission to edit video pages from another clan"
          redirect_to(clan_url(@clan))              
        end
      else
        flash[:error] = "You do not have permission to edit video pages"
        redirect_to(clan_url(@clan))    
      end      
    else
      signed_in_user
    end      
  end
    
  def proper_access_rights
    @video = Video.friendly.find(params[:id])
    if @video.access_type.name != PUBLIC
      if signed_in?
        if @video.access_type.name == CLAN && @video.clan != current_user.clan
          flash[:error] = "You must be a memeber of #{@video.clan.name} to watch those videos"
          redirect_to(clan_url(@video.clan))      
        end
      else
        signed_in_user
      end
    end   
  end
end
