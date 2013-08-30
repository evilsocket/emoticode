class RemoveNewsletterFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :newsletter    
  end
end
