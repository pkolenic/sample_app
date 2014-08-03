class ClansController < ApplicationController
  def show
    @clan = Clan.friendly.find(params[:id])
  end
end
