require 'spec_helper'

describe "Tournament pages" do

  subject { page }
  
  shared_examples_for "all tournament pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  describe "tournament show page as owner" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, team: "#{user.id}") }
    let(:heading)    { tournament.name }
    let(:page_title) { tournament.name }
    
    before do
      sign_in user
      visit tournament_path(tournament) 
    end
    
    it_should_behave_like "all tournament pages"    
    it { should have_link('Edit', href: edit_tournament_path(tournament)) }
    it { should have_link('Delete') }#, href: edit_tournament_path(tournament)) }
    it { should_not have_link('JOIN TEAM') }
    it { should_not have_link('LEAVE TEAM') }
    
    it "should be able to delete a tournament" do
      expect do
        click_link('Delete Tournament', match: :first)
      end.to change(Tournament, :count).by(-1)
    end
  end
  
  describe "tournament show page with status formed" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }    
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, team: "#{user.id}", status: TournamentFormed) }
    
    before do
      sign_in user
      visit tournament_path(tournament) 
    end
    
    it { should have_content('The team is full') }
  end
  
  describe "tournament show page with team full" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let(:user2) { FactoryGirl.create(:user, role: UserSoldier) }   
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 2, maximum_team_size: 2, team: "1, #{user.id}", status: TournamentFormed) }
    
    before do
      sign_in user2
      visit tournament_path(tournament) 
    end
    
    it { should_not have_link('Delete', href: edit_tournament_path(tournament)) }
    it { should have_content('The team is full') }
  end 
  
  describe "tournament show page without minimum team" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 3, team: "1, #{user.id}") }

    before do
      sign_in user
      visit tournament_path(tournament) 
    end    
    
    it { should_not have_link('Close Team') }
    it { should_not have_link('Open Team') }
  end
  
  describe "tournament show page with minimum team" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 2, team: "1, #{user.id}") }

    before do
      sign_in user
      visit tournament_path(tournament) 
    end    
    
    it { should have_link('Close Team') }
    it { should_not have_link('Open Team') }    
  end
  
  describe "tournament show page with minimum team and closed status" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 3, team: "1, #{user.id}", status: TournamentFormed) }

    before do
      sign_in user
      visit tournament_path(tournament) 
    end    
    
    it { should_not have_link('Close Team') }
    it { should have_link('Open Team') }    
  end
  
  describe "closing tournament" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 2, team: "1, #{user.id}") }
    
    before do
      sign_in user
      visit tournament_path(tournament)
      click_link "Close Team"
      tournament.reload.status
    end    
    
    specify { expect(tournament.status).to eq(TournamentFormed) }
  end
  
  describe "opening tournament" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) } 
    let!(:tournament) { FactoryGirl.create(:tournament, user: user, minimum_team_size: 3, team: "1, #{user.id}", status: TournamentFormed) }
    
    before do
      sign_in user
      visit tournament_path(tournament)
      click_link "Open Team"
      tournament.reload.status
    end    
    
    specify { expect(tournament.status).to eq(TournamentForming) }    
  end
  
  describe "new tournment page" do
    let(:heading)    { 'New Tournament' }
    let(:page_title) { 'New Tournament' }
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
    let(:submit) { "Create tournament" }
    
    before do
      sign_in user
      visit  new_tournament_path 
    end
    
    it_should_behave_like "all tournament pages"
    
    describe "with invalid information" do
      it "should not create a tournament" do
        expect { click_button submit }.not_to change(Tournament, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('New Tournament') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in_tournament_form }
      it "should create a tournament" do
        expect { click_button submit }.to change(Tournament, :count).by(1)
      end

      describe "after saving the tournament" do
        before { click_button submit }

        it { should have_selector('h1', text: CLAN_NAME) }
        it { should have_success_message('Tournament Created') }
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
    let!(:tournament) { FactoryGirl.create(:tournament, user: user) }
    before do
      sign_in user
      visit edit_tournament_path(tournament)
    end

    describe "page" do
      let(:heading)    { 'Update the Tournament' }
      let(:page_title) { 'Edit Tournament' }
    
      it_should_behave_like "all tournament pages"
    end

    describe "with invalid information" do
      before do
         fill_in "Team Maximum Tier Points", with: ""
         click_button "Save changes"
      end

      it { should have_content('error') }
    end
  end
end
