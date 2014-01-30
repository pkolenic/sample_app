class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:messageboard]
  
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
    @events = Event.all
    @date = params[:month] ? DateTime.strptime(params[:month], '%Y-%m') : Date.today
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
  
  def tankvideos
    @title = "Tank Guides"
    @disqus = "tankvideos"
    @header = "Tank Guides"
    @video_filter = true
    @default_video = 'cf--U-Mq_S4'
    @videos = [{ id: 'cf--U-Mq_S4', title: 'L&ouml;we'.html_safe, nation: 'German', type: 'Heavy', tier: '8' },
               { id: '9sd2W4a9xcA', title: 'Tiger II', nation: 'German', type: 'Heavy', tier: '8' },
               { id: 'CmIUU97UdXU', title: 'PzKpfw IV (Pre 8.0)', nation: 'German', type: 'Medium', tier: '5' },
               { id: 'NykOlAHQq04', title: 'T-43', nation: 'Soviet', type: 'Medium', tier: '7' },
               { id: 'f2qQzcBN_EY', title: 'PzKpfw III/IV', nation: 'German', type: 'Medium', tier: '5' },
               { id: 'nyrFkOFRTy4', title: 'IS-3', nation: 'Soviet', type: 'Heavy', tier: '8' },
               { id: 'iBLpjumiEj4', title: 'VK 30.01 (H)', nation: 'German', type: 'Heavy', tier: '5' },
               { id: '0bi1gIShurI', title: 'T40', nation: 'American', type: 'TD', tier: '4' },
               { id: 'XLrsk503mTc', title: 'T-28', nation: 'Soviet', type: 'Medium', tier: '4' },
               { id: 'CL7cGBuU5T4', title: 'IS', nation: 'Soviet', type: 'Heavy', tier: '7' },
               { id: 'IWL-PQoIkWg', title: 'M10 Wolverine', nation: 'American', type: 'TD', tier: '5' },
               { id: 'bx7ApLPjb8c', title: 'Jagdpanther', nation: 'German', type: 'TD', tier: '7' },
               { id: '1pnUeMJjNFI', title: 'KV-1 (Pre 7.3)', nation: 'Soviet', type: 'Heavy', tier: '5' },
               { id: 'qRxlVinaTNo', title: 'IS-4 (Pre 7.3)', nation: 'Soviet', type: 'Heavy', tier: '10' },
               { id: '5a12jI5QOsg', title: 'M4 Sherman', nation: 'American', type: 'Medium', tier: '5' },
               { id: 'GjEgcdvBZtQ', title: 'T29', nation: 'American', type: 'Heavy', tier: '7' }]
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
