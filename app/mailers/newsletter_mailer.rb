class NewsletterMailer < ActionMailer::Base
  default from: "weekly@emoticode.net"

  def weekly( user, sources )
    @sources = sources
    puts "Sending weekly newsletter to #{user.email} ..."
    mail( to: user.email, subject: 'EmotiCODE Weekly Newsletter' ) 
  end
end
