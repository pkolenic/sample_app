class TournamentsController < ApplicationController
  before_action :signed_in_user
  before_action :user_can_create_tournament, only: [:new, :create]
  before_action :correct_user,   only: [:edit, :update, :open_tournament, :close_tournament]

  def show
    @tournament = Tournament.find(params[:id])
    @team = User.where("id in (#{@tournament.team})").to_a
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = current_user.tournaments.build(tournament_params)
    if @tournament.save
      flash[:success] = "Tournament Created"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      flash[:success] = "Tournament updated"
      redirect_to @tournament
    else
      render 'edit'
    end
  end

  def destroy
    Tournament.find(params[:id]).destroy
    flash[:success] = "Tournament destroyed."
    redirect_to root_url
  end
  
  def join_tournament
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attribute(:team, add_team_member)
      if @tournament.team.split(',').length == @tournament.maximum_team_size
        TournamentMailer.tournament_max_team_reached(@tournament).deliver
      elsif @tournament.team.split(',').length == @tournament.minimum_team_size
        TournamentMailer.tournament_min_team_reached(@tournament).deliver
      else
        TournamentMailer.user_joined_tournament(current_user, @tournament).deliver
      end
      flash[:success] = "Joined Tournament"
    else
      flash[:error] = "Unable to join Tournament"
    end
    redirect_to request.referer
  end
  
  def leave_tournament
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attribute(:team, remove_team_member)
      if @tournament.team.split(',').length == (@tournament.minimum_team_size - 1)
        TournamentMailer.tournament_lost_min_size(@tournament).deliver
      else
        TournamentMailer.user_left_tournament(current_user, @tournament).deliver
      end 
      flash[:success] = "Left Tournament"
    else
      flash[:error] = "Unable to leave Tournament"
    end
    redirect_to request.referer
  end
  
  def open_tournament
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attribute(:status, TournamentForming)
      flash[:success] = "Tournament has been reopened"
    else
      flash[:error] = "Unable to reopen the Tournament"
    end
    redirect_to request.referer
  end
  
  def close_tournament
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attribute(:status, TournamentFormed)
      flash[:success] = "Tournament has been closed"
    else
      flash[:error] = "Unable to close the Tournament"
    end
    redirect_to request.referer
  end
  
  private
    def tournament_params
      params.require(:tournament).permit(:name, :wot_tournament_link, :wot_team_link, :team_name,
                                         :description, :victory_conditions, :schedule, :prizes, :maps,
                                         :minimum_team_size, :maximum_team_size, :team_maximum_tier_points,
                                         :heavy_tier_limit, :medium_tier_limit, :td_tier_limit, :light_tier_limit, :spg_tier_limit,
                                         :start_date, :end_date)
    end
  
    def add_team_member
      "#{@tournament.team},#{current_user.id}"
    end
    
    def remove_team_member
      members = @tournament.team.split(',')
      members = members - ["#{current_user.id}"]
      members.join(',')      
    end
  
  # Before Filters
    def user_can_create_tournament
      if current_user.role < UserSoldier
        flash[:error] = "You need to be at least a Soldier in #{CLAN_NAME} to create a new Tournament!"
        redirect_to(root_url)        
      end
    end
    
    def correct_user
      @tournament = Tournament.find(params[:id])
      redirect_to(root_url) unless @tournament.user_id == current_user.id
    end
end