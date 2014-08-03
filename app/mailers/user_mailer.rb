class UserMailer < ActionMailer::Base
  
  # Message sent when a new user joins just the alliance
  def joined_alliance(user)
    @user = user
    @url = signin_url(host: ALLIANCE_WEBSITE)
    mail from: ALLIANCE_NOREPLY, to: user.email, subject: "Welcome to #{ALLIANCE_NAME}"
  end
  
  # Message sent when a user applys to a clan
  def applied_to_clan(user, clan)
    @user = user
    if user.clan
      @url = signin_url(host: ALLIANCE_WEBSITE, clan_id: user.clan.slug)
    else
      @url = signin_url(host: ALLIANCE_WEBSITE)
    end
    @clan = clan
    mail from: clan.noreply(), to: user.email, subject: "Application to #{clan.name} pending"
  end
  
  # Message sent when user activates a pre-made account
  def user_activated_account(user)
    @user = user
    @url = signin_url(host: ALLIANCE_WEBSITE, clan_id: user.clan.slug)
    mail from: user.clan.noreply(), to: user.email, subject: "Welcome to #{user.clan.name}'s website"
  end
  
  # Message sent when user activates a pre-made accoount and applys to a new clan
  def user_activated_account_apply_to_clan(user, clan)
    @user = user
    @clan = clan
    @url = signin_url(host: ALLIANCE_WEBSITE, clan_id: user.clan.slug)
    mail from: user.clan.noreply(), to: user.email, subject: "Application to #{clan.name} pending"
  end
  
  # Message sent when user creates another application and previous one is deleted
  def application_deleted(application)
    @user = application.user
    @clan = application.clan
    
    mail from: @clan.noreply(), to: @user.email, subject: "Application to #{@clan.name} removed"
  end
  
  def promoted(user, role, reason)
    @user = user
    @reason = reason
    @role = role
    mail from: user.clan.noreply(), to: user.email, to: user.email, subject: 'You have been promoted'
  end
  
  def demoted(user, role, reason)
    @user = user
    @reason = reason
    @role = role
    mail from: user.clan.noreply(), to: user.email, to: user.email, subject: 'You have been demoted'
  end
  
  def clanwar_added(user)
    @user = user
    mail from: user.clan.noreply(), to: user.email, to: user.email, subject: 'You have been added to the clan war team'
  end
  
  def clanwar_removed(user)
    @user = user
    mail from: user.clan.noreply(), to: user.email, to: user.email, subject: 'You have been removed from the clan war team'
  end
  
  def request_password_reset(user, token)
    @user = user
    clan = user.clan
    @token = token
    if clan
      mail from: user.clan.noreply(), to: user.email, to: user.email, subject: "#{user.clan.name} Website Password Reset Request"  
    else
      mail from: ALLIANCE_NOREPLY, to: user.email, to: user.email, subject: "#{ALLIANCE_NAME} Website Password Reset Request"      
    end 
        
  end
  
  def password_reset(user)
    @user = user
    clan = user.clan
    if clan
      mail from: user.clan.noreply(), to: user.email, to: user.email, subject: "#{user.clan.name} Website Password has been Reset"
    else
      mail from: ALLIANCE_NOREPLY, to: user.email, to: user.email, subject: "#{ALLIANCE_NAME} Website Password has been Reset"
    end         
  end
end
