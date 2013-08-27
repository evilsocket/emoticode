class RenameSourcesAuthorIdToUserId < ActiveRecord::Migration
  def change
    rename_column :sources, :author_id, :user_id
  end
end
