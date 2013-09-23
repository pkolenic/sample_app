class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:riisingsun, :wotvideos]
  
  def home
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def riisingsun
    @title = "RiisingSun"
    @youtube = "TheRiisingSun"
    @disqus = "riisingsun"
    @header = "RiisingSun YouTube Videos"
    render 'videos'
  end
  
  def wotvideos
    @title = "World of Tank Videos"
    @youtube = "WorldOfTanksCom"
    @disqus = "wotvideos"
    @header = "World of Tank Videos"
    render 'videos'
  end
  
  def wgnavideos
    @title = "War Gaming NA Videos"
    @youtube = "WargamingNA"
    @disqus = "wgnavideos"
    @header = "War Gaming North America Videos"
    render 'videos'    
  end
  
  def mapvideos
    @title = "World of Tanks Map Guides"
    @disqus = "mapvideos"
    @header = "World of Tanks Map Guides"
    render 'map_videos'     
  end
  
  private
  
    # Before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end  
end
