class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :title_appointments do |t|
      t.integer :user_id
      t.integer :title_id

      t.timestamps
    end
    add_index :title_appointments, :user_id
    add_index :title_appointments, :title_id
    add_index :title_appointments, [:user_id, :title_id], unique: true
  end
end
