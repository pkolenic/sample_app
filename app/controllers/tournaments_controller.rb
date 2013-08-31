class TournamentsController < ApplicationController
  before_action :signed_in_user

  def show
    @tournament = Tournament.find(params[:id])
    # @team = User.find_all_by_id(@tournament.team.split(','))
    @team = User.where("id in (#{@tournament.team})").to_a
  end

  def new
    @tournament = Tournament.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
end