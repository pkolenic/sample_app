require 'spec_helper'

describe Tournament do
  let(:user) { FactoryGirl.create(:user) }
  # before do
    # @tournament = user.tournaments.build(name: "Example Tournament",
                                         # status: TournamentForming,
                                         # wot_tournament_link: "www.somewhere.com",
                                         # wot_team_link: "www.somewhere.com/teamlink",
                                         # team_name: "Teamname",
                                         # description: "This is a Tournament",
                                         # password: "pancakes",
                                         # minimum_team_size: 3,
                                         # maximum_team_size: 5,
                                         # heavy_tier_limit: 3,
                                         # medium_tier_limit: 3,
                                         # td_tier_limit: 3,
                                         # light_tier_limit: 3,
                                         # spg_tier_limit: 3,
                                         # team_maximum_tier_points: 9,
                                         # victory_conditions: "Kill some tanks and stuff",
                                         # schedule: "When everyone can't make it",
                                         # prizes: "Gold and stuff",
                                         # maps: "Only the one noone likes",
                                         # team: "2,3,4,5",
                                         # start_date: "2099-08-20 18:30:00".to_datetime,
                                         # end_date: "2099-08-26 18:30:00".to_datetime)
  # end
# 
  # subject { @tournament }
# 
  # it { should respond_to(:name) }
  # it { should respond_to(:user_id) }
  # it { should respond_to(:status) }
  # it { should respond_to(:wot_tournament_link) }
  # it { should respond_to(:wot_team_link) }
  # it { should respond_to(:team_name) }
  # it { should respond_to(:description) }
  # it { should respond_to(:password) }
  # it { should respond_to(:minimum_team_size) }
  # it { should respond_to(:maximum_team_size) }
  # it { should respond_to(:heavy_tier_limit) }
  # it { should respond_to(:medium_tier_limit) }
  # it { should respond_to(:td_tier_limit) }
  # it { should respond_to(:light_tier_limit) }
  # it { should respond_to(:spg_tier_limit) }
  # it { should respond_to(:team_maximum_tier_points) }
  # it { should respond_to(:victory_conditions) }
  # it { should respond_to(:schedule) }
  # it { should respond_to(:prizes) }
  # it { should respond_to(:maps) }
  # it { should respond_to(:team) }
  # it { should respond_to(:start_date) }
  # it { should respond_to(:end_date) }
# 
  # it { should respond_to(:user) }
  # its(:user) { should eq user }
#   
  # it { should be_valid }
# 
  # describe "when user_id is not present" do
    # before { @tournament.user_id = nil }
    # it { should_not be_valid }
  # end
# 
  # describe "with blank name" do
    # before { @tournament.name = " " }
    # it { should_not be_valid }
  # end
#   
  # describe "with name that is too long" do
    # before { @tournament.name = "a" * 61 }
    # it { should_not be_valid }
  # end
#   
  # describe "with blank team name" do
    # before { @tournament.team_name = " " }
    # it { should_not be_valid }
  # end
#   
  # describe "with team name that is too long" do
    # before { @tournament.team_name = "a" * 46 }
    # it { should_not be_valid }
  # end
# 
  # describe "with password that is too long" do
    # before { @tournament.password = "a" * 31 }
    # it { should_not be_valid }
  # end
# 
  # describe "with blank minimum_team_size" do
    # before { @tournament.minimum_team_size = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with minimum_team_size that is too small" do
    # before { @tournament.minimum_team_size = 1 }
    # it { should_not be_valid }
  # end
#   
  # describe "with blank maximum_team_size" do
    # before { @tournament.maximum_team_size = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with maximum_team_size that is smaller than miniumum_team_size" do
    # before do 
      # @tournament.minimum_team_size = 3
      # @tournament.maximum_team_size = 2
    # end
    # it { should_not be_valid }
  # end
#   
  # describe "with blank heavy_tier_limit" do
    # before { @tournament.heavy_tier_limit = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with heavy_tier_limit that is too small" do
    # before { @tournament.heavy_tier_limit = 0 }
    # it { should_not be_valid }
  # end
#    
  # describe "with blank medium_tier_limit" do
    # before { @tournament.medium_tier_limit = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with medium_tier_limit that is too small" do
    # before { @tournament.medium_tier_limit = 0 }
    # it { should_not be_valid }
  # end  
#   
  # describe "with blank td_tier_limit" do
    # before { @tournament.td_tier_limit = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with td_tier_limit that is too small" do
    # before { @tournament.td_tier_limit = 0 }
    # it { should_not be_valid }
  # end   
#   
  # describe "with blank light_tier_limit" do
    # before { @tournament.light_tier_limit = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with light_tier_limit that is too small" do
    # before { @tournament.light_tier_limit = 0 }
    # it { should_not be_valid }
  # end  
#   
  # describe "with blank spg_tier_limit" do
    # before { @tournament.spg_tier_limit = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with spg_tier_limit that is too small" do
    # before { @tournament.spg_tier_limit = 0 }
    # it { should_not be_valid }
  # end  
#   
  # describe "with blank team_maximum_tier_points" do
    # before { @tournament.team_maximum_tier_points = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with team_maximum_tier_points that is too small" do
    # before { @tournament.team_maximum_tier_points = 1 }
    # it { should_not be_valid }
  # end   
#   
  # describe "with too many team members" do
    # before { @tournament.team = "1,2,3,4,5,6,7,8,9,10"}
    # it { should_not be_valid}
  # end
#   
  # describe "with blank start_date" do
    # before { @tournament.start_date = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with blank end_date" do
    # before { @tournament.end_date = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with end_date in past" do
    # before { @tournament.end_date = "1970-08-26 18:30:00".to_datetime }
    # it { should_not be_valid }
  # end       
#   
  # describe "with end_date before start_date" do
    # before do 
      # @tournament.start_date = "2099-08-20 18:30:00".to_datetime
      # @tournament.end_date =  "2099-08-15 18:30:00".to_datetime
    # end
    # it { should_not be_valid }
  # end   
#   
  # describe "with blank tournament link" do
    # before { @tournament.wot_tournament_link = '' }
    # it { should_not be_valid }
  # end
#   
  # describe "with blank team link" do
    # before { @tournament.wot_team_link = '' }
    # it { should_not be_valid }
  # end
end