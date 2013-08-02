class AddWotNameAndStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wot_name, :string
    add_column :users, :status, :int
  end
end
