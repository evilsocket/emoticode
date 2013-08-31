class RemoveUselessColumnsFromRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :type
    remove_column :ratings, :visibility
    remove_column :ratings, :data
  end
end
