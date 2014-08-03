class AddWotClanIdIndexToClans < ActiveRecord::Migration
  def change
    add_index :clans, :wot_clanId
  end
end
