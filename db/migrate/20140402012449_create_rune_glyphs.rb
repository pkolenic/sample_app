class CreateRuneGlyphs < ActiveRecord::Migration
  def change
    create_table :rune_glyphs do |t|
      t.string  :name
      t.integer :essence_rune_id
      t.integer :aspect_rune_id
      t.string  :potency_rune_id
      t.string  :item_type_id
      t.string  :description
      t.integer :x_value
      t.integer :y_value

      t.timestamps
    end
  end
end
