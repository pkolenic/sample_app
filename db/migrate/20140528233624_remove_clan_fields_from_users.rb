class RemoveClanFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :clan_name
    remove_column :users, :clan_abbr
    remove_column :users, :clan_logo
  end
end
