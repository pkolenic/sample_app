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
end
