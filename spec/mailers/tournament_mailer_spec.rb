require "spec_helper"

describe TournamentMailer do
  describe 'user_joined_tournament' do
    let(:owner) { FactoryGirl.create(:user, role: UserSoldier, wot_name: 'Lucas', email: 'lucas@email.com') }
    let!(:tournament) { FactoryGirl.create(:tournament, user: owner, name: 'My Tournament', team_name: "Team Name", wot_team_link: 'http://www.somewhere.com/team') }
    let(:user) { mock_model(User, wot_name: 'User', email: 'user@email.com') }
    let(:mail) { TournamentMailer.user_joined_tournament(user, tournament) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'User has joined the tournament: My Tournament'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [owner.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the user @name variable appears in the email body
    it 'assigns user @name' do
      mail.body.encoded.should match(user.wot_name)
    end
    
    #ensure that the owner @name variable appears in the email body
    it 'assigns owner @name' do
      mail.body.encoded.should match(owner.wot_name)
    end
    
    #ensure that the tournament @name variable appears in the email body
    it 'assigns tournament @name' do
      mail.body.encoded.should match(tournament.name)
    end
    
    #ensure that the tournament @team_name variable appears in the email body
    it 'assigns tournament @team_name' do
      mail.body.encoded.should match(tournament.team_name)
    end
    
    #ensure that the tournament @wot_team_link variable appears in the email body
    it 'assigns @wot_team_link' do
      mail.body.encoded.should match(tournament.wot_team_link)
    end
  end
  
  describe 'tournament_min_team_reached' do
    let!(:owner) { FactoryGirl.create(:user, role: UserSoldier, wot_name: 'Lucas', email: 'lucas@email.com') }
    let!(:tanker1) { FactoryGirl.create(:user, wot_name: 'Tanker1') }
    let!(:tanker2) { FactoryGirl.create(:user, wot_name: 'Tanker2') }
    let!(:tournament) { FactoryGirl.create(:tournament, user: owner, name: 'My Tournament', 
                                                        team_name: "Team Name", wot_team_link: 'http://www.somewhere.com/team',
                                                        team: "#{owner.id}, #{tanker1.id}, #{tanker2.id}") }
    let(:team) { %w( Lucas Tanker1 Tanker2 ) }
    let(:mail) { TournamentMailer.tournament_min_team_reached(tournament) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'Tournament "My Tournament" has reached the minimum team size'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [owner.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the team member names variable appears in the email body
    it 'assigns team list' do
      team.each do |member|
        mail.body.encoded.should match(member)
      end
    end
    
    #ensure that the owner @name variable appears in the email body
    it 'assigns owner @name' do
      mail.body.encoded.should match(owner.wot_name)
    end
    
    #ensure that the tournament @name variable appears in the email body
    it 'assigns tournament @name' do
      mail.body.encoded.should match(tournament.name)
    end
    
    #ensure that the tournament @team_name variable appears in the email body
    it 'assigns tournament @team_name' do
      mail.body.encoded.should match(tournament.team_name)
    end
    
    #ensure that the tournament @wot_team_link variable appears in the email body
    it 'assigns @wot_team_link' do
      mail.body.encoded.should match(tournament.wot_team_link)
    end
  end
  
  describe 'tournament_max_team_reached' do
    let!(:owner) { FactoryGirl.create(:user, role: UserSoldier, wot_name: 'Lucas', email: 'lucas@email.com') }
    let!(:tanker1) { FactoryGirl.create(:user, wot_name: 'Tanker1') }
    let!(:tanker2) { FactoryGirl.create(:user, wot_name: 'Tanker2') }
    let!(:tournament) { FactoryGirl.create(:tournament, user: owner, name: 'My Tournament', 
                                                        team_name: "Team Name", wot_team_link: 'http://www.somewhere.com/team',
                                                        team: "#{owner.id}, #{tanker1.id}, #{tanker2.id}") }
    let(:team) { %w( Lucas Tanker1 Tanker2 ) }
    let(:mail) { TournamentMailer.tournament_max_team_reached(tournament) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'Tournament "My Tournament" has reach its full team size'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [owner.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the team member names variable appears in the email body
    it 'assigns team list' do
      team.each do |member|
        mail.body.encoded.should match(member)
      end
    end
    
    #ensure that the owner @name variable appears in the email body
    it 'assigns owner @name' do
      mail.body.encoded.should match(owner.wot_name)
    end
    
    #ensure that the tournament @name variable appears in the email body
    it 'assigns tournament @name' do
      mail.body.encoded.should match(tournament.name)
    end
    
    #ensure that the tournament @team_name variable appears in the email body
    it 'assigns tournament @team_name' do
      mail.body.encoded.should match(tournament.team_name)
    end
    
    #ensure that the tournament @wot_team_link variable appears in the email body
    it 'assigns @wot_team_link' do
      mail.body.encoded.should match(tournament.wot_team_link)
    end
  end
  
  describe 'user_left_tournament' do
    let(:owner) { FactoryGirl.create(:user, role: UserSoldier, wot_name: 'Lucas', email: 'lucas@email.com') }
    let!(:tournament) { FactoryGirl.create(:tournament, user: owner, name: 'My Tournament', team_name: "Team Name", wot_team_link: 'http://www.somewhere.com/team') }
    let(:user) { mock_model(User, wot_name: 'User', email: 'user@email.com') }
    let(:mail) { TournamentMailer.user_left_tournament(user, tournament) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'User has left the tournament: My Tournament'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [owner.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the user @name variable appears in the email body
    it 'assigns user @name' do
      mail.body.encoded.should match(user.wot_name)
    end
    
    #ensure that the owner @name variable appears in the email body
    it 'assigns owner @name' do
      mail.body.encoded.should match(owner.wot_name)
    end
    
    #ensure that the tournament @name variable appears in the email body
    it 'assigns tournament @name' do
      mail.body.encoded.should match(tournament.name)
    end
    
    #ensure that the tournament @team_name variable appears in the email body
    it 'assigns tournament @team_name' do
      mail.body.encoded.should match(tournament.team_name)
    end
    
    #ensure that the tournament @wot_team_link variable appears in the email body
    it 'assigns @wot_team_link' do
      mail.body.encoded.should match(tournament.wot_team_link)
    end
  end  
  
  describe 'tournament_lost_min_size' do
    let!(:owner) { FactoryGirl.create(:user, role: UserSoldier, wot_name: 'Lucas', email: 'lucas@email.com') }
    let!(:tanker1) { FactoryGirl.create(:user, wot_name: 'Tanker1') }
    let!(:tanker2) { FactoryGirl.create(:user, wot_name: 'Tanker2') }
    let!(:tournament) { FactoryGirl.create(:tournament, user: owner, name: 'My Tournament', 
                                                        team_name: "Team Name", wot_team_link: 'http://www.somewhere.com/team',
                                                        team: "#{owner.id}, #{tanker1.id}, #{tanker2.id}") }
    let(:team) { %w( Lucas Tanker1 Tanker2 ) }
    let(:mail) { TournamentMailer.tournament_lost_min_size(tournament) }
    
    #ensure that the subject is correct
    it 'renders the subject' do
      mail.subject.should == 'Tournament "My Tournament" no longer has the minimum team size needed'
    end
 
    #ensure that the receiver is correct
    it 'renders the receiver email' do
      mail.to.should == [owner.email]
    end
 
    #ensure that the sender is correct
    it 'renders the sender email' do
      mail.from.should == [CLAN_NO_REPLAY]
    end
 
    #ensure that the team member names variable appears in the email body
    it 'assigns team list' do
      team.each do |member|
        mail.body.encoded.should match(member)
      end
    end
    
    #ensure that the owner @name variable appears in the email body
    it 'assigns owner @name' do
      mail.body.encoded.should match(owner.wot_name)
    end
    
    #ensure that the tournament @name variable appears in the email body
    it 'assigns tournament @name' do
      mail.body.encoded.should match(tournament.name)
    end
    
    #ensure that the tournament @team_name variable appears in the email body
    it 'assigns tournament @team_name' do
      mail.body.encoded.should match(tournament.team_name)
    end
    
    #ensure that the tournament @wot_team_link variable appears in the email body
    it 'assigns @wot_team_link' do
      mail.body.encoded.should match(tournament.wot_team_link)
    end
  end
end
