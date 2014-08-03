class ApplicationMailer < ActionMailer::Base
  
  # Message sent when a new user joins just the alliance
  def rejected_application(user, clan)
    @user = user
    @clan = clan
    if user.clan
      @url = signin_url(host: ALLIANCE_WEBSITE, clan_id: user.clan.slug)
    else
      @url = signin_url(host: ALLIANCE_WEBSITE)
    end
    mail from: clan.noreply(), to: user.email, subject: "Application to #{clan.name} has been rejected"
  end
end