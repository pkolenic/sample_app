class VideosController < ApplicationController
  def new
  end
  
  def show
    @video = Video.friendly.find(params[:id])
    
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
end
