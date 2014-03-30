class UserMailer < ActionMailer::Base
  default :from => CLAN_NO_REPLAY
  
  def approved(user)
    @user = user
    @url = "#{CLAN_WEBSITE}/signin"
    mail to: user.email, subject: 'Guild Status Approved'
  end  
  
  def request_password_reset(user, token)
    @user = user
    @clan = CLAN_NAME
    @token = token
    mail to: user.email, subject: "#{CLAN_NAME} Password Reset Request"    
  end
  
  def password_reset(user)
    @user = user
    @clan = CLAN_NAME
    mail to: user.email, subject: "#{CLAN_NAME} Password has been Reset"     
  end
end
