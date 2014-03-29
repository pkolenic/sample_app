class CreateGearLevels < ActiveRecord::Migration
  def change
    create_table :gear_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
