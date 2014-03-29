class RarityRenameAsQuality < ActiveRecord::Migration
  def change
    rename_table  :rarities, :qualities
  end
end
