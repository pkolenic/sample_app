class AddClanWarTeamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clan_war_team, :boolean
  end
end
