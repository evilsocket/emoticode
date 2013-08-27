class RemoveUselessColumnsInSource < ActiveRecord::Migration
  def change
    remove_column :sources, :type_id
    remove_column :sources, :archive_id
    drop_table    :source_types
  end
end
