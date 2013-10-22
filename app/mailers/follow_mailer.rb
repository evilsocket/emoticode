class FollowMailer < ActionMailer::Base
  default from: "noreply@emoticode.net"

  def follow( user, who )
    @user = user
    @who  = who

    mail( to: user.email, subject: "#{who.username} started following you!" ) 
  end
end

