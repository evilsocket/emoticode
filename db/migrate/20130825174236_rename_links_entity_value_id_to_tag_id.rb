class RenameLinksEntityValueIdToTagId < ActiveRecord::Migration
  def change
    rename_column :links, :entity_value_id, :tag_id
  end
end
