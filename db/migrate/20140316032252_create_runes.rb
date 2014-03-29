class CreateRunes < ActiveRecord::Migration
  def change
    create_table :runes do |t|
      t.string :name
      t.string :translation
      t.integer :rune_type_id
      t.integer :level
      t.integer :rarity_id

      t.timestamps
    end
    add_index :runes, :rune_type_id
    add_index :runes, :level
    add_index :runes, :rarity_id
  end
end
