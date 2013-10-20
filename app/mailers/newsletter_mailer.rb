class NewsletterMailer < ActionMailer::Base
  default from: "weekly@emoticode.net"

  def weekly( users, sources )
    @sources = sources

    users.each do |u|
      mail( to: u.email, subject: 'EmotiCODE Weekly Newsletter' ) 
    end
  end
end
