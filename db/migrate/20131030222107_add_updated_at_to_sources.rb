class AddUpdatedAtToSources < ActiveRecord::Migration
  def change
    add_column :sources, :updated_at, :integer, :default => 0
  end
end
