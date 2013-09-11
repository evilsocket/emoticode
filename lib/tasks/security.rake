namespace :security do
  desc "Check for fishy users"
  task spammers: :environment do
    User.where('last_login_ip IS NOT NULL').latest.each do |user|
      code, list = Charon.query user.last_login_ip
      unless code.nil? or code > 7 # I'm not interested in policy block list.
        puts "#{user.username} (#{user.email}) - #{user.last_login_ip} : SpamHaus #{list} | DESTROY? (y/n)"
        input = STDIN.gets.strip
        if input == 'y'
          user.destroy!
        end
      end
    end
  end
end

