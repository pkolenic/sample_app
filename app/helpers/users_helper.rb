module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    image_tag gravatar_url(user, options), alt: user.name, id: 'profileImage'
  end

  def sso_auth(user)
    if !Rails.env.test?
      digest = OpenSSL::Digest::Digest.new('sha1')
      disqus_timestamp = Time.now.to_i
      user_id = "#{CLAN_SHORT_NAME.downcase}-#{user.id}#{Rails.env.development? ? '-dev' : ''}"

      disqus_serializer_message = {"id"=>user_id, "username"=>"{CLAN_DISQUS_PREFIX}{user.name}", "email"=>user.email, "avatar"=>gravatar_url(user, {size: 160})}.to_json               
      disqus_message = Base64.strict_encode64(disqus_serializer_message)
      disqus_signature = OpenSSL::HMAC.hexdigest(digest, ENV['DISQUS_SECRET'], disqus_message + ' ' + disqus_timestamp.to_s)
      auth = "#{disqus_message} #{disqus_signature} #{disqus_timestamp}"
    end
  end

  def gravatar_url(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{image_url('logo.png')}"
  end
  
end