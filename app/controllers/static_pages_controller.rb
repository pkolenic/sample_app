class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:messageboard]
  
  def home
    # Grab all the Clan YouTube Channels
    clans = Clan.all
    @youtube_channels = Array.new
    clans.each do |clan|
      if clan.clan_youtube
        @youtube_channels.push clan.clan_youtube
      end
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
    if (params.has_key?(:clan_id))
      @clan = Clan.friendly.find(params[:clan_id])
      render layout: "clans"
    end  
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
  
  def ftfvideos
    @title ="Fear The Fallen Videos"
    @youtube = "fearthefallenclan"
    @disqus = "ftfvideos"
    @header = "Fear The Fallen YouTube Videos"
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
    @videos = [{ id: 'cf--U-Mq_S4', title: 'L&ouml;we'.html_safe,   nation: 'German',   type: 'Heavy',  tier: '8' },
               { id: '9sd2W4a9xcA', title: 'Tiger II',              nation: 'German',   type: 'Heavy',  tier: '8' },
               { id: 'CmIUU97UdXU', title: 'PzKpfw IV (Pre 8.0)',   nation: 'German',   type: 'Medium', tier: '5' },
               { id: 'NykOlAHQq04', title: 'T-43',                  nation: 'Soviet',   type: 'Medium', tier: '7' },
               { id: 'f2qQzcBN_EY', title: 'PzKpfw III/IV',         nation: 'German',   type: 'Medium', tier: '5' },
               { id: 'nyrFkOFRTy4', title: 'IS-3',                  nation: 'Soviet',   type: 'Heavy',  tier: '8' },
               { id: 'iBLpjumiEj4', title: 'VK 30.01 H',            nation: 'German',   type: 'Heavy',  tier: '5' },
               { id: '0bi1gIShurI', title: 'T40',                   nation: 'American', type: 'TD',     tier: '4' },
               { id: 'XLrsk503mTc', title: 'T-28',                  nation: 'Soviet',   type: 'Medium', tier: '4' },
               { id: 'CL7cGBuU5T4', title: 'IS',                    nation: 'Soviet',   type: 'Heavy',  tier: '7' },
               { id: 'IWL-PQoIkWg', title: 'M10 Wolverine',         nation: 'American', type: 'TD',     tier: '5' },
               { id: 'bx7ApLPjb8c', title: 'Jagdpanther',           nation: 'German',   type: 'TD',     tier: '7' },
               { id: 'qRxlVinaTNo', title: 'IS-4 (Pre 7.3)',        nation: 'Soviet',   type: 'Heavy',  tier: '10' },
               { id: '5a12jI5QOsg', title: 'M4 Sherman',            nation: 'American', type: 'Medium', tier: '5' },
               { id: 'GjEgcdvBZtQ', title: 'T29',                   nation: 'American', type: 'Heavy',  tier: '7' },
               { id: 'lduqYYEAVqQ', title: 'VK 30.01 (P)',          nation: 'German',   type: 'Medium', tier: '6' },
               { id: '-cYisixsBU4', title: 'E 75',                  nation: 'German',   type: 'Heavy',  tier: '9' },
               { id: '0AyCKFYwY_k', title: 'M6',                    nation: 'American', type: 'Heavy',  tier: '6' },
               { id: '45_AbVXkY5w', title: 'KV-3 (pre 7.3)',        nation: 'Soviet',   type: 'Heavy',  tier: '7' },
               { id: 'xoHFkKj-4_E', title: 'AMX 40',                nation: 'French',   type: 'Light',  tier: '4' },
               { id: '00Z_HEVnjYA', title: 'M36 Jackson',           nation: 'American', type: 'TD',     tier: '6' },
               { id: 'y4gcKVWI9PE', title: 'AMX 12t',               nation: 'French',   type: 'Light',  tier: '6' },
               { id: '5AJlAhnEfRc', title: 'T32',                   nation: 'American', type: 'Heavy',  tier: '8' },
               { id: 'GG28TedXR54', title: 'B1',                    nation: 'French',   type: 'Heavy',  tier: '4' },
               { id: 'Td1AEP-Q39o', title: 'SU-85B',                nation: 'Soviet',   type: 'TD',     tier: '4' },
               { id: 'MRxAGuLuvb0', title: 'BDR G1B',               nation: 'French',   type: 'Heavy',  tier: '5' },
               { id: 'H65zUdKIs2c', title: 'M4A3E8',                nation: 'American', type: 'Medium', tier: '6' },
               { id: 'oNOzn7o4bKs', title: 'M4A3E2',                nation: 'American', type: 'Medium', tier: '6' },
               { id: 'PAh2WqbobgU', title: 'Tiger',                 nation: 'German',   type: 'Heavy',  tier: '7' },
               { id: 'k5mOt-OzalE', title: 'PzKpfw III',            nation: 'German',   type: 'Medium', tier: '4' },
               { id: '_G_cDa4ksgI', title: 'Panther',               nation: 'German',   type: 'Medium', tier: '7' },
               { id: 'QZ2eir4G4xs', title: 'T-34',                  nation: 'Soviet',   type: 'Medium', tier: '5' },
               { id: 'd6-lNePY8Ok', title: 'JagdPz IV',             nation: 'German',   type: 'TD',     tier: '6' },
               { id: 'flVShtE0bQg', title: 'T-34-85',               nation: 'Soviet',   type: 'Medium', tier: '6' },
               { id: '_7yv5dqqxLs', title: 'M3 Lee',                nation: 'Amerian',  type: 'Medium', tier: '4' },               
               { id: 'LMbLhQexKFc', title: 'StuG III',              nation: 'German',   type: 'TD',     tier: '5' },
               { id: '3Aw2Z_qsf54', title: 'VK 30.02 D',            nation: 'German',   type: 'Medium', tier: '7' },
               { id: 'TnODSWOm_F8', title: 'M8A1',                  nation: 'American', type: 'TD',     tier: '4' },
               { id: '_9KCfveONJ0', title: 'AMX 13 75',             nation: 'French',   type: 'Light',  tier: '7' },
               { id: '1CBYx-DqIRc', title: 'Tiger P',               nation: 'German',   type: 'Heavy',  tier: '7' },
               { id: 'Y0wBlfYdZtQ', title: 'T20',                   nation: 'American', type: 'Medium', tier: '7' },
               { id: 'S1X7oNL7HR0', title: 'SU 85',                 nation: 'Soviet',   type: 'TD',     tier: '5' },
               { id: 'qWJHb5a8QUs', title: 'ARL 44',                nation: 'French',   type: 'Heavy',  tier: '6' },
               { id: '4KsXUeseVK0', title: 'T-44',                  nation: 'Soviet',   type: 'Medium', tier: '8' },
               { id: 'P-k4jS8alsg', title: 'T49',                   nation: 'American', type: 'TD',     tier: '5' },
               { id: '4ISMF_jWKF4', title: 'T1 Heavy',              nation: 'American', type: 'Heavy',  tier: '5' },
               { id: 'rxym7K8FR7Y', title: 'VK 36.01 H',            nation: 'German',   type: 'Heavy',  tier: '6' },
               { id: '_wZEz7ocwIs', title: 'IS-7',                  nation: 'Soviet',   type: 'Heavy',  tier: '10' },
               { id: 'D84uwR5lZlw', title: 'KV-1',                  nation: 'Soviet',   type: 'Heavy',  tier: '5' },
               { id: 'E92n8UZVmJM', title: 'KV-2',                  nation: 'Soviet',   type: 'Heavy',  tier: '6' },
               
               
               { id: 'pYfjWX4gT2c', title: 'Hetzer',                nation: 'German',   type: 'TD',     tier: '4' },
               { id: '-AZKQh61zxw', title: 'PzKpfw IV',             nation: 'German',   type: 'Medium', tier: '5' },
               { id: 'Owc5FMt-pMY', title: 'ELC AMC',               nation: 'French',   type: 'Light',  tier: '5' },
               { id: 'LqP0dFHeI-Q', title: 'Churchhill III',        nation: 'Soviet',   type: 'Heavy',  tier: '5' },
               { id: '14Q42dAT3sM', title: 'Covenanter',            nation: 'British',  type: 'Light',  tier: '4' }               
               ]
               
    render 'static_videos'    
  end
  
  private
  
    # Before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in"
      end
    end 
end
