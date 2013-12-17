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
      disqus_serializer_message = {"id"=>user_id, "username"=>user.wot_name, "email"=>user.email, "avatar"=>gravatar_url(user, {size: 160})}.to_json               
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
  
  def win_rate_color(rate)
    case rate.round
    when 0..44
      color = "255,0,0"
    when 45..49
      color = "255,100,0"
    when 50..54
      color = "100,255,0"
    when 55..74
      color = "100,255,100"
    when 75..84
      color = "100,255,255"
    else
      color = "75,125,75"
    end
    color;
  end
  
  def win7_color(value)
    case value
    when 0..499
      color = "255,0,0"
    when 500..699
      color = "255,100,0"
    when 700..899
      color = "100,255,0"
    when 900..1099
      color = "100,255,100"
    when 1100..1349
      color = "100,255,255"
    when 1350..1499
      color = "0,255,100"
    when 1500..1699
      color = "100,100,100"
    when 1700..1999
      color = "10,255,255"
    else
      color = "75,125,75"
    end
    color                        
  end
end