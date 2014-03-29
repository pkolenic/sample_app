class AddGearLevelIdAndRunePrefixIdToRunes < ActiveRecord::Migration
  def change
      add_column :runes, :glyph_prefix_id, :integer
      add_column :runes, :gear_level_id, :integer  
  end
end
