class AddRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rank, :int, :default => 0
  end
end
