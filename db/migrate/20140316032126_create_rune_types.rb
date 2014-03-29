class CreateRuneTypes < ActiveRecord::Migration
  def change
    create_table :rune_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
