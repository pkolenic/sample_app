class AddWotStatsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wot_id, :string
    add_column :users, :wins, :bigint
    add_column :users, :losses, :bigint
    add_column :users, :battles_count, :bigint
    add_column :users, :spotted, :bigint
    add_column :users, :frags, :bigint
    add_column :users, :survived, :bigint
    add_column :users, :experiance, :bigint
    add_column :users, :max_experiance, :bigint
    add_column :users, :capture_points, :bigint
    add_column :users, :defense_points, :bigint
    add_column :users, :damage_dealt, :bigint
    add_column :users, :hit_percentage, :bigint
    
    add_index  :users, :wot_id
  end
end
