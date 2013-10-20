class NewsletterMailer < ActionMailer::Base
  default from: "weekly@emoticode.net"

  def weekly( sources )
    @sources = sources

   # User.confirmed.each do |u|
      mail( to: 'evilsocket@gmail.com', subject: 'EmotiCODE Weekly Newsletter' ) 
   # end
  end
end
