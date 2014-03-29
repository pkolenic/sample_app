class RunesRenameRarityIdToQualityId < ActiveRecord::Migration
  def change
    rename_column :runes, :rarity_id, :quality_id
  end
end
