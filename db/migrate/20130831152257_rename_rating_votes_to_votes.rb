class RenameRatingVotesToVotes < ActiveRecord::Migration
  def change
    rename_table :rating_votes, :votes        
  end
end
