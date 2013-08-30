class UserMailer < ActionMailer::Base
  default from: "noreply@emoticode.net"

  def confirmation_email(user,password)
    @user     = user
    @token    = user.confirmation_token
    @password = password

    mail( to: @user.email, subject: 'EmotiCODE Account Confirmation' )
  end

  def omniauth_confirmation_email(user,provider,password)
    @user     = user
    @provider = provider
    @password = password

    mail( to: @user.email, subject: 'Welcome to EmotiCODE' )
  end

  def comment_email(from,to,url)
    @from = from
    @user = to
    @url  = url

    mail( to: @user.email, subject: 'Comment on EmotiCODE' )
  end

  def comment_reply_email(from,to,url)
    @from = from
    @user = to
    @url  = url

    mail( to: @user.email, subject: 'Comment reply on EmotiCODE' )
  end
end
