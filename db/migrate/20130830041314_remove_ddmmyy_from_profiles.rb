class RemoveDdmmyyFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :dd
    remove_column :profiles, :mm    
    remove_column :profiles, :yy        
  end
end
