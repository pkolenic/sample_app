class ChangeGearLeveIdColumnType < ActiveRecord::Migration
  def change
    change_column :potency_runes, :gear_level_id, 'integer USING CAST(gear_level_id AS integer)'
  end
end
