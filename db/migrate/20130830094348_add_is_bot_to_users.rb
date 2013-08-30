class AddIsBotToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_bot, :integer, :default => 0
    emobot = User.find_by_username('emobot')
    unless emobot.nil?
      emobot.is_bot = 1
      emobot.save!
    end
  end
end
