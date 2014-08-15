class AddYoutubeAndTwitchToClans < ActiveRecord::Migration
  def change
    add_column :clans, :clan_youtube, :string
    add_column :clans, :clan_twitch,  :string
  end
end
