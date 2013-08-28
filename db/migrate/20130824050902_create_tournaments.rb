class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :user_id
      t.integer :status, :default => 0
      t.string :wot_tournament_link
      t.string :wot_team_link
      t.string :team_name
      t.text :description
      t.string :password
      t.integer :minimum_team_size
      t.integer :maximum_team_size
      t.integer :heavy_tier_limit
      t.integer :medium_tier_limit
      t.integer :td_tier_limit
      t.integer :light_tier_limit
      t.string :spg_tier_limit
      t.integer :team_maximum_tier_points
      t.text :victory_conditions
      t.text :schedule
      t.text :prizes
      t.text :maps
      t.string :team
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
    
    add_index  :tournaments, :end_date
  end
end
