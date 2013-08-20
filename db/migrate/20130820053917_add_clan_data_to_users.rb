class AddClanDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :clan_id,    :string
    add_column :users, :clan_name,  :string
    add_column :users, :clan_abbr,  :string
    add_column :users, :clan_logo,  :string
  end
end
