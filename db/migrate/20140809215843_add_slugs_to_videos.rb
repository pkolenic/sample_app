class AddSlugsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :slug, :string
    add_index :videos, :id, unique: true
    add_index :videos, :slug, unique: true    
  end
end
