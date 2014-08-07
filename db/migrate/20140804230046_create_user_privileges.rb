class CreateUserPrivileges < ActiveRecord::Migration
  def change
    create_table :user_privileges do |t|
      t.integer :user_id
      t.integer :privilege_id

      t.timestamps
    end
  end
end
