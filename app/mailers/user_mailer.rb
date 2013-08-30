class UserMailer < ActionMailer::Base
  default from: "noreply@emoticode.net"

  def confirmation_email(user,password)
    @user     = user
    @token    = user.confirmation_token
    @password = password

    mail( to: @user.email, subject: 'EmotiCODE Account Confirmation' )
  end
end
