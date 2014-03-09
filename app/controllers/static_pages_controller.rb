class StaticPagesController < ApplicationController
  def home
  end

  def guildhall    
  end
  
  def library
  end

  def messageboard
    @disqus = "general"
  end

  def about
  end

  def contact
  end
  
end
