class RenameUserFavoritesToFavorites < ActiveRecord::Migration
  def change
    rename_table :user_favorites, :favorites
  end
end
