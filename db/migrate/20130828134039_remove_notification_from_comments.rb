class RemoveNotificationFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :notification
  end
end
