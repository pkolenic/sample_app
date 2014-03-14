class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :name
      t.string :region

      t.timestamps
    end
    add_index :titles, [:name]
  end
end
