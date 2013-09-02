class UserMailer < ActionMailer::Base
  default :from => 'noreply@fearthefallen.net'
  
  def approved(user)
    @user = user
    @url = 'https://fearthefallen.herokuapp.com/signin'
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
    @clan = 'Fear The Fallen'
    mail to: user.email, subject: "You have been appointed as an ambassador to Fear the Fallen for #{user.clan_name}"
  end
  
  def request_password_reset(user, token)
    @user = user
    @clan = 'Fear The Fallen'
    @token = token
    mail to: user.email, subject: "FearTheFallen Password Reset Request"    
  end
  
  def password_reset(user)
    @user = user
    @clan = 'Fear The Fallen'
    mail to: user.email, subject: "FearTheFallen Password has been Reset"     
  end
end
