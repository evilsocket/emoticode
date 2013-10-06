class DeleteEventableTypeFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :eventable_type    
  end
end
