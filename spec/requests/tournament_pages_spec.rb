require 'spec_helper'

describe "Tournament pages" do

  subject { page }
  
  shared_examples_for "all tournament pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  describe "tournament show page" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
    let!(:tournament) { FactoryGirl.create(:tournament, user: user) }
    let(:heading)    { tournament.name }
    let(:page_title) { tournament.name }
    
    before do
      sign_in user
      visit tournament_path(tournament) 
    end
    
    it_should_behave_like "all tournament pages"    
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

        it { should have_selector('h1', text: 'Fear The Fallen') }
        it { should have_success_message('Tournament Created') }
      end
    end
  end
  
end
