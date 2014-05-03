class AddFavCountToSources < ActiveRecord::Migration
  def change
    add_column :sources, :fav_count, :integer, :default => 0

    # Source.reset_column_information
    # Source.find_each do |source|
    #  source.fav_count = source.favorites.count
    #  source.save
    # end
  end
end
