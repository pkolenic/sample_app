class AddClanPeroidicStatsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avg_tier, :float
    #24hr
    add_column :users, :wins_24hr, :bigint
    add_column :users, :losses_24hr, :bigint
    add_column :users, :battles_count_24hr, :bigint
    add_column :users, :spotted_24hr, :bigint
    add_column :users, :frags_24hr, :bigint
    add_column :users, :survived_24hr, :bigint
    add_column :users, :experiance_24hr, :bigint
    add_column :users, :capture_points_24hr, :bigint
    add_column :users, :defense_points_24hr, :bigint
    add_column :users, :damage_dealt_24hr, :bigint
    add_column :users, :hit_percentage_24hr, :bigint
    add_column :users, :avg_tier_24hr, :float
    #7day
    add_column :users, :wins_7day, :bigint
    add_column :users, :losses_7day, :bigint
    add_column :users, :battles_count_7day, :bigint
    add_column :users, :spotted_7day, :bigint
    add_column :users, :frags_7day, :bigint
    add_column :users, :survived_7day, :bigint
    add_column :users, :experiance_7day, :bigint
    add_column :users, :capture_points_7day, :bigint
    add_column :users, :defense_points_7day, :bigint
    add_column :users, :damage_dealt_7day, :bigint
    add_column :users, :hit_percentage_7day, :bigint   
    add_column :users, :avg_tier_7day, :float 
    #30day
    add_column :users, :wins_30day, :bigint
    add_column :users, :losses_30day, :bigint
    add_column :users, :battles_count_30day, :bigint
    add_column :users, :spotted_30day, :bigint
    add_column :users, :frags_30day, :bigint
    add_column :users, :survived_30day, :bigint
    add_column :users, :experiance_30day, :bigint
    add_column :users, :capture_points_30day, :bigint
    add_column :users, :defense_points_30day, :bigint
    add_column :users, :damage_dealt_30day, :bigint
    add_column :users, :hit_percentage_30day, :bigint    
    add_column :users, :avg_tier_30day, :float
    #60day
    add_column :users, :wins_60day, :bigint
    add_column :users, :losses_60day, :bigint
    add_column :users, :battles_count_60day, :bigint
    add_column :users, :spotted_60day, :bigint
    add_column :users, :frags_60day, :bigint
    add_column :users, :survived_60day, :bigint
    add_column :users, :experiance_60day, :bigint
    add_column :users, :capture_points_60day, :bigint
    add_column :users, :defense_points_60day, :bigint
    add_column :users, :damage_dealt_60day, :bigint
    add_column :users, :hit_percentage_60day, :bigint    
    add_column :users, :avg_tier_60day, :float
  end
end