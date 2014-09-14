class AddOrderAndActiveToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :order, :int
    add_column :videos, :active, :boolean, default: true    
  end
end
