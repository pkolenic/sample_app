Forem.user_class = "User"
Forem.email_from_address = "fearthefallenclan@gmail.com"
Forem.sign_in_path = "/signin"
Forem.moderate_first_post = false
Forem.user_profile_links = true
# If you do not want to use gravatar for avatars then specify the method to use here:
# Forem.avatar_user_method = :custom_avatar_url
Forem.per_page = 20
Forem.layout = 'application'

#Rails.application.config.to_prepare do
#   If you want to change the layout that Forem uses, uncomment and customize the next line:
#   Forem::ApplicationController.layout "application"
#
#   If you want to add your own cancan Abilities to Forem, uncomment and customize the next line:
#   Forem::Ability.register_ability(Ability)
#end
#
# By default, these lines will use the layout located at app/views/layouts/forem.html.erb in your application.
