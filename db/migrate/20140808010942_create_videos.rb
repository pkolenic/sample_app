class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :disqus
      t.string :header
      t.string :youtube_channel
      t.string :video_list
      t.integer :clan_id
      t.integer :access_type_id

      t.timestamps
    end
  end
end
