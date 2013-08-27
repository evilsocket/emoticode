class RenameEntityValuesToTags < ActiveRecord::Migration
  def change
    rename_table :entity_values, :tags
    rename_table :entity_connectors, :links
  end
end
