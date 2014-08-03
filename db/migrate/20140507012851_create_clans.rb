class CreateClans < ActiveRecord::Migration
  def change
    create_table :clans do |t|
      t.string    :name
      t.string    :wot_clanId
      t.string    :clan_short_name
      t.string    :clan_email  
      t.string    :clan_motto
      t.string    :clan_google_plus_id 
      t.text      :clan_requirements
      t.text      :clan_about
      t.string    :clan_logo
      t.string    :slug
      
      t.timestamps
    end
    
    add_index :clans, :id
    add_index :clans, :slug, unique: true
  end
end
