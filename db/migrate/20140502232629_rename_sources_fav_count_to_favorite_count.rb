class RenameSourcesFavCountToFavoriteCount < ActiveRecord::Migration
  def change
    rename_column :sources, :fav_count, :favorites_count    
  end
end
