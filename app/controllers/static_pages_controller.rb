class StaticPagesController < ApplicationController
  force_ssl :except => :contact
  before_action :signed_in_user, only: [:riisingsun]
  
  def home
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def riisingsun
  end
  
  private
  
    # Before filters
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end  
end
