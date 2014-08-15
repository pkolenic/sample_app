class AddFiltersToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :filters, :text    
  end
end
