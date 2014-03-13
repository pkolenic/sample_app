class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :deck
      t.boolean :public, default: false
      t.datetime :start_time
      t.datetime :end_time
      t.integer :user_id

      t.timestamps
    end
    add_index :events, [:user_id, :start_time]
  end
end
