class CreateGlyphPrefixes < ActiveRecord::Migration
  def change
    create_table :glyph_prefixes do |t|
      t.string :name

      t.timestamps
    end
  end
end
