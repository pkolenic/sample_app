module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    if user.clan_name == 'Fear the Fallen' || user.clan_name.blank?
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{request.protocol}#{request.host_with_port}#{image_path('logo.png')}"
    else
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{user.clan_logo}"
    end
    # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{request.protocol}#{request.host_with_port}#{image_path('logo.png')}"
    # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=https://fearthefallen.herokuapp.com/assets/logo-6dfef04d5fad85fcff9ff34f039373d2.png"
    #link_to image_tag(gravatar_url, alt: user.name, id: 'profileImage'), 'http://gravatar.com', target: "_blank", title: "Change your avatar at Gravatar."
    image_tag gravatar_url, alt: user.name, id: 'profileImage'
  end

  def role_for(user)
    case user.role
    when UserRecruit
      return 'Recruit'
    when UserSoldier
      return 'Soldier'
    when UserTreasurer
      return 'Treasurer'
    when UserRecruiter
      return 'Recruiter'
    when UserDiplomat
      return 'Diplomat'
    when UserCompanyCommander
      return 'Company Commander'
    when UserDeputyCommander
      return 'Deputy Commander'
    when UserCommander
      return 'Commander'
    when UserAmbassador
      return "Ambassador from #{user.clan_name}"
    else
    return "spy"
    end
  end

end