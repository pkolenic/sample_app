class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:riisingsun, :wotvideos, :wgnavideos, :mapvideos, :schedule]
  
  def home
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def links    
  end
  
  def mods
  end
  
  def messageboard
    @disqus = "general"
  end
  
  def schedule
    @disqus = "schedule"
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
    @default_video = 'sP0uk76wuq8'
    @videos = [{ id: 'sP0uk76wuq8', title: 'World of Tanks. Map guide - Sacred Valley' },
               { id: '5cv4G59BY3c', title: 'World of Tanks 8.7 Patch Review' },
               { id: 'k4DZau_l-EI', title: 'World of Tanks. 8.8 Maps review' },
               { id: '7GOFyQv9dlM', title: "RissingSun's Ruinberg" },
               { id: 'B2o9r0d0cWU', title: "RissingSun's Malinovka" },
               { id: 'c5nAObZA9EI', title: "RiisingSun's Prokhorovka" },
               { id: 'DnGU623s6Rw', title: "RissingSun's El Halluf" },
               { id: 'O1qKyBqMmps', title: "RissingSun's South Coast" },
               { id: 'AjvjhHcI_cA', title: "RiisingSun's Westfield" },
               { id: '78Ih381ZaLA', title: "RiisingSun's Komarin" },
               { id: 'rul-AsK39WQ', title: "QuickyBabyTv's Sand River" },
               { id: 'qBZB536sOYo', title: "QuickyBabyTv's Redshire" },
               { id: 'CbpT_xbdFYg', title: "QuickyBabyTv's Airfield" },
               { id: 'FlmOoUOtcBY', title: "QuickyBabyTv's Arctic Region" },
               { id: 'Nvuje-sme_A', title: "QuickyBabyTv's Pearl River" },
               { id: 'E6pfEYA_y9U', title: "Phalhell's Abbey" }]
    render 'static_videos'    
    # render 'map_videos'     
  end
  
  def teamtrainingvideos
    @title = "World of Tanks Team Training Videos"
    @disqus = "teamvideos"
    @header = "World of Tanks Team Training Videos"
    @default_video = '8wcx0lPceBI'
    @videos = [{ id: '8wcx0lPceBI', title: 'World of Tanks. Tank Academy, ep.1' },
               { id: 'T0BmaJ3DPmQ', title: 'World of Tanks. Tank Academy, ep.2' },
               { id: 'LsbMrLuiqmE', title: 'World of Tanks. Tank Academy, ep.3' },
               { id: 'yW6w-d8Q5Lo', title: 'World of Tanks. Tank Academy, ep.4' },
               { id: 'DBYMYiLyjao', title: 'World of Tanks. Tank Academy, ep.5' }]
    render 'static_videos'
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
