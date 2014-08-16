class VideosController < ApplicationController
  before_action :proper_access_rights,      only: [:show]
   
  def new
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
  
  private
  
  # Before filters
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
