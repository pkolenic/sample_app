class RenameAsspectRuneToAspectRune < ActiveRecord::Migration
  def change
    rename_table  :asspect_runes, :aspect_runes
  end
end
