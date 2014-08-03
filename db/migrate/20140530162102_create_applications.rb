class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.integer :user_id
      t.integer :clan_id
      
      t.timestamps
    end
    
    add_index :applications, :clan_id
    add_index :applications, :user_id, unique: true
  end
end