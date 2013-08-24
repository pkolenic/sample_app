class AddDefaultRoleToUsers < ActiveRecord::Migration
  def change
    change_column :users, :role, :int, :default => 0
  end
end
