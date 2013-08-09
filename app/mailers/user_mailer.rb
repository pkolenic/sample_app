class UserMailer < ActionMailer::Base
  default :from => 'noreply@fearthefallen.net'
  
  def approved(user)
    @user = user
    @url = 'https://fearthefallen.herokuapp.com/signin'
    mail :to => user.email, :subject => 'Clan Status Approved'
  end
end
