class RenameCommentsObjectTypeAndObjectIdToCommentable < ActiveRecord::Migration
  def change
    rename_column :comments, :object_id,   :commentable_id
    rename_column :comments, :object_type, :commentable_type
  end
end
