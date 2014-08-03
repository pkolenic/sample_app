require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "redirecting to signin page" do
    let(:clan)        { FactoryGirl.create(:clan) }    
    describe "when redirecting from non clan page" do
      before { visit forem_path }
      
      specify { current_url.should eq signin_url }
    end
    
    describe "when redirecting from clan page" do
      before do
        visit clan_path(clan)
        click_link "Battle Roster"
      end
      
      specify{ current_url.should eq signin_url(:clan_id => clan.slug) }
    end
  end

  describe "signin" do
    
    describe "with invalid information" do
      before do
        visit signin_path
        click_button "Sign in"
      end

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
      
      it { should_not have_link('Profile') }
      it { should_not have_link('Settings') }
      it { should_not have_link('Sign out',    href: signout_path) }
      it { should have_link('Sign in', href: signin_path) }
    end

    describe "with valid information" do
      let(:clan) { FactoryGirl.create(:clan) }
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user, clan_id: clan.id) }
      let(:params) do
          { user: { name: user.name, email: 'new_user@example.com',
                  password: user.password, password_confirmation: user.password } }
      end
      
      describe "user in clan" do
        before { sign_in user2 }
        
        it { should have_link('Profile',     href: clan_user_path(clan.slug, user2.slug)) }
        it { should have_link('Settings',    href: edit_clan_user_path(clan.slug, user2.slug)) }        
        it { should_not have_link('Sign in', href: signin_path(:clan_id => clan.slug)) }
      end
      
      describe "user not in clan" do
        before { sign_in user }
        
        it { should have_link('Profile',     href: user_path(user)) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
      end
      
      describe "common behaviour" do
        before { sign_in user }
        
        it { should have_title(user.name) }
        it { should have_link('Sign out',    href: signout_path) }        
        it { should_not have_link('Sign in', href: signin_path) }
      
        describe "don't display `sign up` button" do
          before { click_link "Home" }
          specify { expect(page).not_to have_link("Apply to Alliance", href: signup_path)}
        end
      
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
    
    describe "with inactive user" do
      let(:clan)      { FactoryGirl.create(:clan) }
      let(:user)      { FactoryGirl.create(:user, active: false)}
      let(:clan_user) { FactoryGirl.create(:user, active: false, clan_id: clan.id) }
      let(:params) do
          { user: { name: user.name, email: 'new_user@example.com',
                  password: user.password, password_confirmation: user.password } }
      end
      
      shared_examples_for "all inactive user" do
        specify { current_url.should eq url }
        it { should have_error_message('User not active, setup account to activate') }
      end
      
      describe "not in a clan" do
        let(:url) { signup_url }
        before { sign_in user }
        it_should_behave_like "all inactive user"
      end
      
      describe "in a clan" do
        let(:url) { signup_url(:clan_id => clan.slug) }
        before { sign_in clan_user }
        it_should_behave_like "all inactive user"
      end           
    end
  end
  
  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:clan) { FactoryGirl.create(:clan) }
      # let!(:tournament) { FactoryGirl.create(:tournament, user: user) }

      describe "visiting a protected page" do
        before do
          visit edit_user_path(user)
          valid_signin user
        end

        describe "should redirect to page after signin" do
          specify { current_url.should eq edit_user_url(user) }            
        end
        
        describe "should redirect to profile on next login" do
          before do
            delete signout_path
            visit signin_path
            valid_signin user
          end
          
          specify { current_url.should eq user_url(user) }
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          specify { current_url.should eq signin_url }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "visiting the battle roster" do
          before { visit clan_users_path(clan) }
          specify { current_url.should eq signin_url(:clan_id => clan.slug) }
        end
      end
#       
      # describe "in the Tournament controller" do
# 
        # describe "visiting the edit page" do
          # before { visit edit_tournament_path(tournament) }
          # it { should have_title('Sign in') }
        # end
# 
        # describe "submitting to the update action" do
          # before { patch tournament_path(tournament) }
          # specify { expect(response).to redirect_to(signin_path) }
        # end
      # end
#       
      # describe "in the Tournaments controller" do
        # let!(:tournament) {user.tournaments.build(name: "Example Tournament",
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
                                         # end_date: "2099-08-26 18:30:00".to_datetime)}
#          
        # describe "submitting to the create action" do
          # before { post tournaments_path }
          # specify { expect(response).to redirect_to(signin_path) }
        # end
# 
        # describe "submitting to the destroy action" do
          # before { delete tournament_path(FactoryGirl.create(:tournament)) }
          # specify { expect(response).to redirect_to(signin_path) }
        # end
#         
        # describe "visiting the edit page" do
          # before { visit edit_tournament_path(tournament) }
          # it { should have_title('Sign in') }
        # end
# 
        # describe "submitting to the update action" do
          # before { patch tournament_path(FactoryGirl.create(:tournament)) }
          # specify { expect(response).to redirect_to(signin_path) }
        # end
      # end
#       
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end  
    end
    
    describe "as non tournament owner" do
      let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com", role: UserSoldier) }
      let!(:tournament) { FactoryGirl.create(:tournament, user: user) }
      before { sign_in wrong_user, no_capybara: true }

      describe "visiting Tournament#edit page" do
        before { visit edit_tournament_path(tournament) }
        it { should_not have_title(full_title('Edit Tournament')) }
      end

      describe "submitting a PATCH request to the Tournament#update action" do
        before { patch tournament_path(tournament) }
        specify { expect(response).to redirect_to(root_url) }
      end   
      
      describe "submitting a PATCH request to the Tournament#open_tournament action" do
        before { patch open_tournament_path(tournament) }
        specify { expect(response).to redirect_to(root_url) }
      end  
      
      describe "submitting a PATCH request to the Tournament#close_tournament action" do
        before { patch close_tournament_path(tournament) }
        specify { expect(response).to redirect_to(root_url) }
      end             
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end 
    
    describe "as non-leadership user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_leader) { FactoryGirl.create(:user) }
      
      before { sign_in non_leader, no_capybara: true }
      
      describe "submitting a Clan War Appointment to the Users#add_clanwar action" do
        before { patch add_clanwar_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a Clan War removal to the User#remove_clanwar action" do
        before { patch remove_clanwar_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end   
  end
end
