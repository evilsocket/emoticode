class AddHandleToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :handle, :string, :default => nil
  end
end
