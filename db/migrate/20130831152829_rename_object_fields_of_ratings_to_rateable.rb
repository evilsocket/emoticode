class RenameObjectFieldsOfRatingsToRateable < ActiveRecord::Migration
  def change
    rename_column :ratings, :object_id,   :rateable_id
    rename_column :ratings, :object_type, :rateable_type
  end
end
