class RenameUsersHashToPasswordHash < ActiveRecord::Migration
  def change
    rename_column :users, :hash, :password_hash
  end
end
