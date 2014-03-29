class CreateAsspectRunes < ActiveRecord::Migration
  def change
    create_table :asspect_runes do |t|
      t.string :name
      t.string :translation
      t.integer :level
      t.integer :quality_id

      t.timestamps
    end
  end
end
