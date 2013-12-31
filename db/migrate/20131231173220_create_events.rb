class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :event_start
      t.datetime :event_end
      t.integer :event_type
      t.integer :ref_id

      t.timestamps
    end
  end
end
