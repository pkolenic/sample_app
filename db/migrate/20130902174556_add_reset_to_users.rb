class AddResetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_expire, :datetime
    
    add_index  :users, :reset_token
  end
end
