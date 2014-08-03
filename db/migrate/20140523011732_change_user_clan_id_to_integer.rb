class ChangeUserClanIdToInteger < ActiveRecord::Migration
  def change
    reversible do |dir|      
      change_table :users do |t|
        dir.up { t.change :clan_id, 'integer USING CAST(clan_id AS integer)'}
        dir.down { t.change :clan_id, :string }
      end
    end
  end
end
