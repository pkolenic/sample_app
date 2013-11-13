module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    image_tag gravatar_url(user, options), alt: user.name, id: 'profileImage'
  end

  def sso_auth(user)
    if !Rails.env.test?
      digest = OpenSSL::Digest::Digest.new('sha1')
      disqus_timestamp = Time.now.to_i
      user_id = "ftf-#{user.id}#{Rails.env.development? ? '-dev' : ''}"
           
      # disqus_serializer_message = {"id"=>user_id, "username"=>user.wot_name, "email"=>user.email, "avatar"=>user.clan_logo}.to_json
      disqus_serializer_message = {"id"=>user_id, "username"=>user.wot_name, "email"=>user.email, "avatar"=>gravatar_url(user)}.to_json               
      disqus_message = Base64.strict_encode64(disqus_serializer_message)
      disqus_signature = OpenSSL::HMAC.hexdigest(digest, ENV['DISQUS_SECRET'], disqus_message + ' ' + disqus_timestamp.to_s)
      auth = "#{disqus_message} #{disqus_signature} #{disqus_timestamp}"
    end
  end

  def gravatar_url(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    if user.clan_name == 'Fear the Fallen' || user.clan_name.blank?
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{request.protocol}#{request.host_with_port}#{image_path('logo.png')}"
    else
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{user.clan_logo}"
    end
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

  def self.convert_role(role, clan)
    if clan == 'Fear the Fallen'
      case role
      when 'recruit'
        role_id = UserRecruit
      when 'private'
        role_id = UserSoldier
      when 'treasurer'
        role_id =UserTreasurer
      when 'recruiter'
        role_id = UserRecruiter
      when 'diplomat'
        role_id = UserDiplomat
      when 'commander'
        role_id= UserCompanyCommander
      when 'vice_leader'
        role_id = UserDeputyCommander
      when 'leader'
        role_id =UserCommander
      end
    else
      role_id = UserAmbassador
    end
    role_id
  end
end