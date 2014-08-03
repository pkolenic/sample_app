class RenameUserWotNameToName < ActiveRecord::Migration
  def change
    rename_column :users, :wot_name, :name
  end
end
