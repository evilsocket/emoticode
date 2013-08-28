class RemoveStatusAuthorEmailIpFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :status
    remove_column :comments, :author
    remove_column :comments, :email
    remove_column :comments, :ip
  end
end
