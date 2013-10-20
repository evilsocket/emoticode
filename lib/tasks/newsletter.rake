namespace :newsletter do
  desc "Send weekly newsletter"
  task weekly: :environment do
    users   = User.joins(:profile).where(:profiles => {:weekly_newsletter => 1})
    sources = Source.public.where( 'created_at >= UNIX_TIMESTAMP() - 604800' )
    NewsletterMailer.weekly(users,sources).deliver
  end
end

