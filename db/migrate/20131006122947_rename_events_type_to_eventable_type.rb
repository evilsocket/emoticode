class RenameEventsTypeToEventableType < ActiveRecord::Migration
  def change
    rename_column :events, :type, :eventable_type    
  end
end
