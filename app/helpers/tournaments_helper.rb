module TournamentsHelper
  
 def onTeam?(user, team)
   team.split(',').include? user.id.to_s
 end
 
end