class UserMailer < ActionMailer::Base
  default :from => CLAN_NO_REPLAY
  
  def approved(user)
    @user = user
    @url = "#{CLAN_WEBSITE}/signin"
    mail to: user.email, subject: 'Clan Status Approved'
  end
  
  def promoted(user, role, reason)
    @user = user
    @reason = reason
    @role = role
    mail to: user.email, subject: 'You have been promoted'
  end
  
  def demoted(user, role, reason)
    @user = user
    @reason = reason
    @role = role
    mail to: user.email, subject: 'You have been demoted'
  end
  
  def clanwar_added(user)
    @user = user
    mail to: user.email, subject: 'You have been added to the clan war team'
  end
  
  def clanwar_removed(user)
    @user = user
    mail to: user.email, subject: 'You have been removed from the clan war team'
  end
  
  def made_ambassador(user)
    @user = user
    @clan = CLAN_NAME
    if user.clan_name
      mail to: user.email, subject: "You have been appointed as an ambassador to #{CLAN_NAME} for #{user.clan_name}"
    else
      mail to: user.email, subject: "You have been appointed as an ambassador to #{CLAN_NAME}"
    end            
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
