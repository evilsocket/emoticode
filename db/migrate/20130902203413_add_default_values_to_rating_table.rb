class AddDefaultValuesToRatingTable < ActiveRecord::Migration
  def change
    change_column_default :ratings, :votes, 0
    change_column_default :ratings, :average, 0
  end
end
