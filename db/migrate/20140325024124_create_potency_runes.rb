class CreatePotencyRunes < ActiveRecord::Migration
  def change
    create_table :potency_runes do |t|
      t.string :name
      t.string :translation
      t.integer :level
      t.integer :glyph_prefix_id
      t.string :gear_level_id

      t.timestamps
    end
  end
end
