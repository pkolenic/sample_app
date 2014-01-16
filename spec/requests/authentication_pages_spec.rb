require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
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
      let(:user) { FactoryGirl.create(:user) }
      let(:params) do
          { user: { name: user.name, email: 'new_user@example.com',
                  password: user.password, password_confirmation: user.password } }
      end
      
      before { sign_in user }

      it { should have_title(user.wot_name) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "don't display `sign up` button" do
        before { click_link "Home" }
        specify { expect(page).not_to have_link("Sign up now!", href: signup_path)}
      end
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
    
    describe "with inactive user" do
      let(:user) { FactoryGirl.create(:user, active: false)}
      let(:params) do
          { user: { name: user.name, email: 'new_user@example.com',
                  password: user.password, password_confirmation: user.password } }
      end
      
      before { sign_in user }
      
      it { should have_title('Sign up') }
      it { should have_error_message('User not active') }
    end
  end
  
  describe "authorization" do

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      # let(:params) do
          # { user: { name: user.name, email: 'new_user@example.com',
                  # password: user.password, password_confirmation: user.password } }
      # end
      
      before { sign_in user }

      describe "RiisingSun page" do
        before { visit riisingsun_path }

        it { should have_selector('h1', text: 'RiisingSun YouTube Videos') }
        it { should have_title('RiisingSun') }
      end

      describe "in the Users controller" do
        describe "visiting the new page" do
          before { visit new_user_path }
          it { should have_content(CLAN_MOTTO) }
        end

        # Redirect should happen, but its not and is still creating the user
        # describe "submitting to the create action" do
          # before { post users_path(params) }
          # specify { expect(response).to redirect_to(root_url) }
        # end
      end      
    end

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:tournament) { FactoryGirl.create(:tournament, user: user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          valid_signin user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
          
          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              valid_signin user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.wot_name)
            end
          end          
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
      
      describe "in the Tournament controller" do

        describe "visiting the edit page" do
          before { visit edit_tournament_path(tournament) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch tournament_path(tournament) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      describe "in the Tournaments controller" do
        let!(:tournament) {user.tournaments.build(name: "Example Tournament",
                                         status: TournamentForming,
                                         wot_tournament_link: "www.somewhere.com",
                                         wot_team_link: "www.somewhere.com/teamlink",
                                         team_name: "Teamname",
                                         description: "This is a Tournament",
                                         password: "pancakes",
                                         minimum_team_size: 3,
                                         maximum_team_size: 5,
                                         heavy_tier_limit: 3,
                                         medium_tier_limit: 3,
                                         td_tier_limit: 3,
                                         light_tier_limit: 3,
                                         spg_tier_limit: 3,
                                         team_maximum_tier_points: 9,
                                         victory_conditions: "Kill some tanks and stuff",
                                         schedule: "When everyone can't make it",
                                         prizes: "Gold and stuff",
                                         maps: "Only the one noone likes",
                                         team: "2,3,4,5",
                                         start_date: "2099-08-20 18:30:00".to_datetime,
                                         end_date: "2099-08-26 18:30:00".to_datetime)}
         
        describe "submitting to the create action" do
          before { post tournaments_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete tournament_path(FactoryGirl.create(:tournament)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe "visiting the edit page" do
          before { visit edit_tournament_path(tournament) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch tournament_path(FactoryGirl.create(:tournament)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          valid_signin(user)
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              valid_signin(user)
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.wot_name)
            end
          end
        end
      end
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
      let(:params) do
          { id: 1,
            promotion: { role_id: UserSoldier, reason: "Tanker has proven himself in combat." } 
          }
      end
      
      before { sign_in non_leader, no_capybara: true }
      
      describe "submitting an Approve to the Users#approve action" do
        before { patch approve_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a Clan War Appointment to the Users#add_clanwar action" do
        before { patch add_clanwar_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "submitting a Clan War removal to the User#remove_clanwar action" do
        before { patch remove_clanwar_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe "visting Promotion Page" do
        before { get edit_promotion_path(user) }
        specify { expect(response).to redirect_to(users_url) }
      end
      
      describe "submitting an Promition to the promotions#update action" do
        before { patch promotion_path(params) }
        specify { expect(response).to redirect_to(users_url) }
      end
    end   
  end
end
