class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id
      t.integer :title_id

      t.timestamps
    end
    add_index :appointments, :user_id
    add_index :appointments, :title_id
    add_index :appointments, [:user_id, :title_id], unique: true
  end
end
