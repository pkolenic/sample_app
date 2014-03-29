module RuneHelper
  def rune_lore_master
    if signed_in?
      unless current_user.has_title_with_name?('Enchantment')
        flash[:error] = "You don't have permissions to create a Rune!"
        redirect_to runes_url
      end
    else
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
end