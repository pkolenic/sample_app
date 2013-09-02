class TournamentMailer < ActionMailer::Base
  default :from => 'noreply@fearthefallen.net'
  
  def user_joined_tournament(user, tournament)
    @user = user
    @tournament = tournament
    @owner = tournament.user
    mail to: @owner.email, subject: "#{user.wot_name} has joined the tournament: #{tournament.name}"
  end
  
  def user_left_tournament(user, tournament)
    @user = user
    @tournament = tournament
    @owner = tournament.user
    mail to: @owner.email, subject: "#{user.wot_name} has left the tournament: #{tournament.name}"    
  end
  
  def tournament_min_team_reached(tournament)
    @tournament = tournament
    @owner = tournament.user
    @team = User.where("id in (#{@tournament.team})").to_a
    
    mail to: @owner.email, subject: "Tournament \"#{tournament.name}\" has reached the minimum team size"
  end
  
  def tournament_max_team_reached(tournament)
    @tournament = tournament
    @owner = tournament.user
    @team = User.where("id in (#{@tournament.team})").to_a
    
    mail to: @owner.email, subject: "Tournament \"#{tournament.name}\" has reach its full team size"    
  end

  def tournament_lost_min_size(tournament)
    @tournament = tournament
    @owner = tournament.user
    @team = User.where("id in (#{@tournament.team})").to_a
    
    mail to: @owner.email, subject: "Tournament \"#{tournament.name}\" no longer has the minimum team size needed"      
  end
end
