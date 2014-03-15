class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.string :title

      t.timestamps
    end
  end
end
