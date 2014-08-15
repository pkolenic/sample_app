class VideosChangeVideoListToText < ActiveRecord::Migration
  def change
    reversible do |dir|      
      change_table :videos do |t|
        dir.up { t.change :video_list, :text }
        dir.down { t.change :video_list, :string }
      end
    end
  end
end
