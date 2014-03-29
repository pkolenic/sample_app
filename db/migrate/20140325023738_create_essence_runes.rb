class CreateEssenceRunes < ActiveRecord::Migration
  def change
    create_table :essence_runes do |t|
      t.string :name
      t.string :translation

      t.timestamps
    end
  end
end
