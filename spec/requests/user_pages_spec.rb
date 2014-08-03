require 'spec_helper'

describe "User pages" do

  subject { page }

  shared_examples_for "all user pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  shared_examples_for "bad_reset_request" do
    it { should_not have_selector('h1', text: heading) }
    it { should_not have_title(full_title(page_title)) }
  end
  
  describe "index" do
    
    let(:heading) { 'Battle Roster' }
    let(:page_title) { 'Battle Roster' }
    let!(:clan) { FactoryGirl.create(:clan) }
    let!(:user) { FactoryGirl.create(:user, clan_id: clan.id, role: UserSoldier) }
    before(:each) do
      sign_in user
      visit clan_users_path(clan)
    end
  
    it_should_behave_like "all user pages"
    
    describe "pagination" do
      before do
         15.times { FactoryGirl.create(:user, clan_id: clan.id) }
         visit clan_users_path(clan)
      end      

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.where("clan_id = ?", clan.id).paginate(page: 1, :per_page => 10).order(:id).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin, clan_id: clan.id) }
        before do
          sign_in admin
          visit clan_users_path(clan)
        end

        it { should have_link('delete', href: user_path(user)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end   
  end # describe "index"
  
  describe "clanwar links" do
    let!(:clan_1)                  { FactoryGirl.create(:clan) }
    let!(:clan_2)                  { FactoryGirl.create(:clan) }
    let!(:cw_leadership)           { FactoryGirl.create(:user, clan_id: clan_1.id, role: UserDeputyCommander) }
    let!(:user_clan_1_cw_team)     { FactoryGirl.create(:user, clan_id: clan_1.id, clan_war_team:true) }
    let!(:user_clan_1_no_cw_team)  { FactoryGirl.create(:user, clan_id: clan_1.id) }
    let!(:user_clan_2_cw_team)     { FactoryGirl.create(:user, clan_id: clan_2.id, clan_war_team:true) }
    let!(:user_clan_2_no_cw_team)  { FactoryGirl.create(:user, clan_id: clan_2.id) }
    
    describe "as non-member of clan" do
      before do 
        sign_in cw_leadership, no_capybara: true
        visit clan_users_path(clan_2)
      end
      
      it { should_not have_link('add to clanwar team') }
      it { should_not have_link('remove from clanwar team')}
      
      describe "when attempting to add user to clanwar team" do
          before { patch add_clanwar_path(user_clan_2_no_cw_team) }
          
          specify { expect(response).to redirect_to(clan_users_path(clan_2)) }
          specify { expect(request.flash[:error]).to eq 'You do not have permission to appoint clanwar members for this clan!' }        
      end
      
      describe "when attempting to remove user from clanwar team" do
          before { patch remove_clanwar_path(user_clan_2_cw_team) }
          
          specify { expect(response).to redirect_to(clan_users_path(clan_2)) }
          specify { expect(request.flash[:error]).to eq 'You do not have permission to remove clanwar members for this clan!' }        
      end      
    end
    
    describe "as non CW Leadership of clan" do
      before do
        sign_in user_clan_1_cw_team
        visit clan_users_path(clan_1)
      end
      
      it { should_not have_link('add to clanwar team') }
      it { should_not have_link('remove from clanwar team')}
      
      describe "when attempting to add user to clanwar team" do
          before do
             sign_in user_clan_1_cw_team, no_capybara: true
             patch add_clanwar_path(user_clan_1_no_cw_team)
           end
          
          specify { expect(response).to redirect_to(clan_users_path(clan_1)) }
          specify { expect(request.flash[:error]).to eq 'You do not have permission to appoint clanwar members for this clan!' }
      end
      
      describe "when attempting to remove user from clanwar team" do
          before do
            sign_in user_clan_1_cw_team, no_capybara: true
            patch remove_clanwar_path(user_clan_1_cw_team)
          end
          
          specify { expect(response).to redirect_to(clan_users_path(clan_1)) }
          specify { expect(request.flash[:error]).to eq 'You do not have permission to remove clanwar members for this clan!' }        
      end        
    end
    
    describe "as CW Leadership of clan" do
      before do
        sign_in cw_leadership
        visit clan_users_path(clan_1)
      end
      
      it { should have_link('add to clanwar team', href: add_clanwar_path(user_clan_1_no_cw_team)) }
      it { should have_link('remove from clanwar team', href: remove_clanwar_path(user_clan_1_cw_team)) }
      
      describe "when attempting to add user to clanwar team" do
        shared_examples_for "all add clanwar" do
          before  { user_clan_1_no_cw_team.reload }
          specify { expect(user_clan_1_no_cw_team).to be_clanwar_member }
          specify { expect(ActionMailer::Base.deliveries.last.to).to eq [user_clan_1_no_cw_team.email] }         
        end
        
        describe "via patch" do
          before do
            sign_in cw_leadership, no_capybara: true
            patch add_clanwar_path(user_clan_1_no_cw_team)
          end
          
          it_should_behave_like "all add clanwar"
          specify { expect(request.flash[:success]).to eq "#{user_clan_1_no_cw_team.name} has been appointed to the clan war team" }
        end
        
        describe "via link" do
          before do
            cw_leadership.update_attribute(:clan_war_team, true)
            visit clan_users_path(clan_1)
            click_link('add to clanwar team', match: :first)
          end
          
          it_should_behave_like "all add clanwar"
          it { should have_success_message("#{user_clan_1_no_cw_team.name} has been appointed to the clan war team") }        
        end               
      end

      describe "when attempting to remove user from clanwar team" do
        shared_examples_for "all remove clanwar" do
          specify { expect(user_clan_1_cw_team.reload).not_to be_clanwar_member }
          specify { expect(ActionMailer::Base.deliveries.last.to).to eq [user_clan_1_cw_team.email] }         
        end
          
        describe "via patch" do
          before do
            sign_in cw_leadership, no_capybara: true
            patch remove_clanwar_path(user_clan_1_cw_team)
          end
          
          it_should_behave_like "all remove clanwar"  
          specify { expect(request.flash[:success]).to eq "#{user_clan_1_cw_team.name} has been removed from the clan war team" }
        end
          
        describe "via link" do
          before { click_link('remove from clanwar team', match: :first) }
          
          it_should_behave_like "all remove clanwar"
          it { should have_success_message("#{user_clan_1_cw_team.name} has been removed from the clan war team") }     
        end
      end      
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:clan) { FactoryGirl.create(:clan, name:"Fear the Fallen") }
    let(:heading)    { user.name }
    let(:page_title) { user.name }
    before { visit user_path(user) }

    it_should_behave_like "all user pages"

    #TODO need to test the profile page.
  end

  describe "signup page" do
     let(:clan)        { FactoryGirl.create(:clan) }
     let(:clan2)        { FactoryGirl.create(:clan) }
    
    describe "visited when no current user" do
      describe "going to signup page" do
        let(:page_title)  { 'Signup' }
        let(:heading)     { "Signup to #{ALLIANCE_NAME}" }
        before { visit signup_path }
        
        specify { current_url.should eq signup_url }
        it_should_behave_like "all user pages"
        
        # Check for fields
        it { should have_selector('span.warning', text: "As a security measure, it is advised that you do not use the same password as your World of Tanks account.") }               
        it { should have_field("user[name]") }
        it { should have_field("user[email]") }
        it { should have_field("user[password]") }
        it { should have_field("user[password_confirmation]") }
        it { should have_field("user[time_zone]") }
        it { should have_field("user[clan_id]") }
        it { should have_selector("input[type=submit][value='Join Alliance']")}                  
      end
      
      describe "going to a clan signup page" do
        let(:page_title)  { "Apply | #{clan.name}" }
        let(:heading)     { "Apply to #{clan.name}" }
        before { visit signup_path(:clan_id => clan.slug) }
        
        specify { current_url.should eq signup_url(:clan_id => clan.slug) }
        it_should_behave_like "all user pages"
        
         # Check for fields   
        it { should have_selector('span.warning', text: "As a security measure, it is advised that you do not use the same password as your World of Tanks account.") }            
        it { should have_field("user[name]") }
        it { should have_field("user[email]") }
        it { should have_field("user[password]") }
        it { should have_field("user[password_confirmation]") }
        it { should have_field("user[time_zone]") }
        it { should_not have_field("user[clan_id]") }
        it { should have_selector("input[type=submit][value='Apply to Clan']")}              
      end  
    end
    
    describe "visited when user in a clan" do
      let(:user)        { FactoryGirl.create(:user, clan_id: clan.id) }
      before { sign_in user }
      
      describe "going to signup page" do
        before { visit signup_path }
        specify { current_url.should eq clan_url(clan) }
        it { should have_error_message('You already belong to a clan, visit another clan\'s page to apply to their clan') }
      end
      
      describe "going to clan signup page" do
        before { visit signup_path(:clan_id => clan.slug) }
        specify { current_url.should eq clan_url(clan) }
        it { should have_error_message('You already belong to this clan') }
      end
      
      describe "going to another clan signup page" do
        let(:page_title)  { "Apply | #{clan2.name}" }
        let(:heading)     { "Apply to #{clan2.name}" }
        
        before { visit signup_path(:clan_id => clan2.slug) }        
        specify { current_url.should eq signup_url(:clan_id => clan2.slug) }
        it_should_behave_like "all user pages"
        
        # Check for fields        
        it { should_not have_selector('span.warning', text: "As a security measure, it is advised that you do not use the same password as your World of Tanks account.") }
        it { should have_selector('h2', text: "Clicking on Apply will create an application for joining #{clan2.name} You will be notified when the application has been processed" ) }
        it { should_not have_field("user[name]") }
        it { should_not have_field("user[email]") }
        it { should_not have_field("user[password]") }
        it { should_not have_field("user[password_confirmation]") }
        it { should_not have_field("user[time_zone]") }
        it { should_not have_field("user[clan_id]") }        
        it { should have_selector("input[type=submit][value='Apply to Clan']")}         
      end
    end
    
    describe "visited when user not in a clan" do
      let(:user)        { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "going to signup page" do
        before { visit signup_path }
        specify { current_url.should eq root_url }
        it { should have_error_message('You already have an account, visit a clan page if you would like to join a clan') }
      end
      
      describe "going to a clan signup page" do
        let(:page_title)  { "Apply | #{clan.name}" }
        let(:heading)     { "Apply to #{clan.name}" }
        
        before { visit signup_path(:clan_id => clan.slug) }
        specify { current_url.should eq signup_url(:clan_id => clan.slug) }        
        it_should_behave_like "all user pages"
        
        # Check for fields      
        it { should_not have_selector('span.warning', text: "As a security measure, it is advised that you do not use the same password as your World of Tanks account.") }  
        it { should have_selector('h2', text: "Clicking on Apply will create an application for joining #{clan.name} You will be notified when the application has been processed" ) }
        it { should_not have_field("user[name]") }
        it { should_not have_field("user[email]") }
        it { should_not have_field("user[password]") }
        it { should_not have_field("user[password_confirmation]") }
        it { should_not have_field("user[time_zone]") }
        it { should_not have_field("user[clan_id]") }
        it { should have_selector("input[type=submit][value='Apply to Clan']")}               
      end
    end
  end

  describe "user should only have a single application" do
    let!(:clan)         { FactoryGirl.create(:clan) }
    let!(:clan2)        { FactoryGirl.create(:clan) }
    let!(:user)         { FactoryGirl.create(:user, active: true) }
    let!(:application)  { FactoryGirl.create(:application, user_id: user.id, clan_id: clan2.id) }
    let(:submit)        { "Apply to Clan" }
    
    before do
      sign_in user
      visit signup_path(:clan_id => clan.slug)
    end
    
    it "should not create an appplication" do
        expect { click_button submit }.not_to change(Application, :count)
    end
    
    describe "apply to another clan" do
      before { click_button submit }
      
      specify { expect(Application.last.user).to eq user }
      specify { expect(Application.last.clan).to eq clan }
      
      specify { expect(Application.where("user_id = ?", user.id).to_a.size).to eq 1 }
    end
    
  end

  describe "signup" do
    let!(:clan)         { FactoryGirl.create(:clan) }
    let!(:clan2)        { FactoryGirl.create(:clan) }
    let!(:clan1_user)   { FactoryGirl.create(:user, clan_id: clan.id, active: false) }
    let!(:clan2_user)   { FactoryGirl.create(:user, clan_id: clan2.id, active: false) }
    
    shared_examples_for "all invalid information on signup" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      it "should not create an appplication" do
        expect { click_button submit }.not_to change(Application, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it_should_behave_like "all user pages"
        it { should have_content('error') }
      end
    end
    
    shared_examples_for "with application" do
      it "should create an application" do
        expect { click_button submit }.to change(Application, :count).by(1)
      end
      
      describe "that is correct" do  
        before { click_button submit }
                
        specify { expect(Application.last.user).to eq user }
        specify { expect(Application.last.clan).to eq application_clan }
      end
    end
    
    shared_examples_for "new user application" do
      it "should create an application" do
        expect { click_button submit }.to change(Application, :count).by(1)
      end
      
      describe "that is correct" do  
        before { click_button submit }
        
        describe "check application" do
          let!(:user)     { User.last }
                  
          specify { expect(Application.last.user).to eq user }
          specify { expect(Application.last.clan).to eq application_clan }
        end        
      end      
    end    
    
    shared_examples_for "new signups" do
      before { click_button submit }
      
      describe "check fields" do
        let!(:user)    { User.last }
        
        specify { expect(page).to have_selector('div.alert.alert-success', text: message) }         
        specify { expect(ActionMailer::Base.deliveries.last.subject).to eq subject }    
        specify { current_url.should eq user_url(user) }
        specify { expect(user.clan).to eq test_clan }  
        specify { expect(user.active).to eq true }  
        specify { expect(ActionMailer::Base.deliveries.last.to).to eq [user.email] }        
      end
    end
    
    shared_examples_for "all signups" do
      before { click_button submit }
          
      specify { expect(page).to have_selector('div.alert.alert-success', text: message) }         
      specify { expect(ActionMailer::Base.deliveries.last.subject).to eq subject }    
      specify { current_url.should eq url }
      specify { expect(user.reload.clan).to eq test_clan }  
      specify { expect(user.reload.active).to eq true }  
      specify { expect(ActionMailer::Base.deliveries.last.to).to eq [user.reload.email] }
    end
               
    describe "when no current user" do
      describe "joining off alliance signup page" do
        let(:submit)    { "Join Alliance" }        
        before { visit signup_path }
        
        describe "with invalid information" do            
          let(:page_title)  { 'Signup' }
          let(:heading)     { "Signup to #{ALLIANCE_NAME}" }
          it_should_behave_like "all invalid information on signup"
        end # with invalid information
        
        describe "as new clanless user" do
          let(:message)             { "Welcome to #{ALLIANCE_NAME}" }
          let(:subject)             { "Welcome to #{ALLIANCE_NAME}" }
          let(:test_clan)           { nil }
          let(:application_clan)    { nil }
          
          before do
            user = User.new(name: "Tanker", email: "user@example.com", password: "foobar")
            fill_in_user_form_with_user(user, nil)
          end
          
          it "should create a user" do
            expect { click_button submit }.to change(User, :count).by(1)                            
          end    
          
          it "should not create an application" do
            expect { click_button submit }.not_to change(Application, :count)
          end  
          
          it_should_behave_like "new signups"            
        end # as new clanless user    
        
        describe "as new clan user" do
          let(:message)             { "Your application to #{clan.name} is pending" }
          let(:subject)             { "Application to #{clan.name} pending" }
          let(:test_clan)           { nil }
          let(:application_clan)    { clan }       
          
          before do
            user = User.new(name: "Tanker", email: "user@example.com", password: "foobar", clan_id: clan.id)
            fill_in_user_form_with_user(user, clan)
          end  

          it "should create a user" do
            expect { click_button submit }.to change(User, :count).by(1)                            
          end    
                    
          it_should_behave_like "new signups"  
          it_should_behave_like "new user application"          
        end    
        
        describe "as inactive clan user in same clan" do
          let(:message)             { "Welcome to #{clan.name}" }
          let(:subject)             { "Welcome to #{clan.name}'s website" }
          let(:test_clan)           { clan }
          let(:application_clan)    { nil }
          let(:url)                 { clan_user_url(clan, clan1_user) }
          let(:user)                { clan1_user }
          
          before { fill_in_user_form_with_user(user, clan) }
          
          it "should not create a user" do
            expect { click_button submit }.to_not change(User, :count)
          end
                
          it "should not create an application" do
            expect { click_button submit }.not_to change(Application, :count)
          end  
                         
          it_should_behave_like "all signups"             
        end
        
        describe "as inactive clan user joining a different clan" do
          let(:message)             { "Welcome to #{clan.name}, your application to #{clan2.name} is pending" }
          let(:subject)             { "Application to #{clan2.name} pending" }
          let(:test_clan)           { clan }
          let(:application_clan)    { clan2 }
          let(:user)                { clan1_user }
          let(:url)                 { clan_user_url(clan, clan1_user) } 

          before do
            fill_in_user_form_with_user(user, clan2)
          end
                 
          it "should not create a user" do
            expect { click_button submit }.to_not change(User, :count)
          end
                         
          it_should_behave_like "all signups"     
          it_should_behave_like "with application"     
        end    
      end # joining off alliance signup page
      
      describe "joining from clan page" do
        let(:submit)    { "Apply to Clan" }
        before { visit signup_path(:clan_id => clan.slug) }
        
        describe "with invalid information" do           
          let(:page_title)  { "Apply | #{clan.name}" }
          let(:heading)     { "Apply to #{clan.name}" }
          it_should_behave_like "all invalid information on signup"
        end # with invalid information
        
        describe "as new user" do
          let(:message)             { "Your application to #{clan.name} is pending" }
          let(:subject)             { "Application to #{clan.name} pending" }
          let(:test_clan)           { nil }
          let(:application_clan)    { clan }
          
          before do
            user = User.new(name: "Tanker", email: "user@example.com", password: "foobar")
            fill_in_user_form_with_user(user, nil)            
          end
          
          it "should create a user" do
            expect { click_button submit }.to change(User, :count).by(1)                            
          end    

                            
          it_should_behave_like "new signups"
          it_should_behave_like "new user application"
        end
        
        describe "as inactive user in same clan" do
          let(:message)             { "Welcome to #{clan.name}" }
          let(:subject)             { "Welcome to #{clan.name}'s website" }
          let(:test_clan)           { clan }
          let(:application_clan)    { nil }
          let(:user)                { clan1_user }
          let(:url)                 { clan_user_url(clan, clan1_user) }
          
          before do
            fill_in_user_form_with_user(user, nil)            
          end

          it "should not create a user" do
            expect { click_button submit }.to_not change(User, :count)
          end
                  
          it "should not create an application" do
            expect { click_button submit }.not_to change(Application, :count)
          end  
                  
          it_should_behave_like "all signups"          
        end
        
        describe "as inactive user in another clan" do
          let(:message)             { "Welcome to #{clan2.name}, your application to #{clan.name} is pending" }
          let(:subject)             { "Application to #{clan.name} pending" }
          let(:test_clan)           { clan2 }
          let(:application_clan)    { clan }
          let(:user)                { clan2_user }
          let(:url)                 { clan_user_url(clan2, clan2_user) }
          
          before do
            fill_in_user_form_with_user(user, nil)            
          end
          
          it "should not create a user" do
            expect { click_button submit }.to_not change(User, :count)
          end
                  
          it_should_behave_like "all signups"   
          it_should_behave_like "with application"         
        end
      end # joining from clan page
    end # when no current user
    
    describe "when current user not in a clan" do
      let(:submit)              { "Apply to Clan" }
      let(:user)                { FactoryGirl.create(:user, active: true) }
      let(:message)             { "Your application to #{clan.name} is pending" }
      let(:subject)             { "Application to #{clan.name} pending" }
      let(:test_clan)           { nil }
      let(:application_clan)    { clan }
      let(:url)                { user_url(user) }
          
      before do
         sign_in user
         visit signup_path(:clan_id => clan.slug)
       end
       
      it "should not create a user" do
        expect { click_button submit }.to_not change(User, :count)
      end
               
      it_should_behave_like "all signups"
      it_should_behave_like "with application"
    end # when current user not in a clan
    
    describe "when current user in a clan" do
      let(:submit)              { "Apply to Clan" }
      let(:user)                { FactoryGirl.create(:user, active: true, clan_id: clan2.id)}
      let(:message)             { "Your application to #{clan.name} is pending" }
      let(:subject)             { "Application to #{clan.name} pending" }
      let(:test_clan)           { clan2 }
      let(:application_clan)    { clan }
      let(:url)                { clan_user_url(clan2, user) }
      
      before do
         sign_in user
         visit signup_path(:clan_id => clan.slug)
      end   

      it "should not create a user" do
        expect { click_button submit }.to_not change(User, :count)
      end
        
      it_should_behave_like "all signups"   
      it_should_behave_like "with application"    
    end # when current user in a clan
  end # signup
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      let(:heading)    { 'Update your profile' }
      let(:page_title) { 'Edit user' }
    
      it_should_behave_like "all user pages"
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(user.name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.email).to eq new_email }
      it { should have_success_message('Profile updated') }
    end
    
    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before { patch user_path(user), params }
      specify { expect(user.reload).not_to be_admin }
    end
  end
  
  describe "password reset" do
    let(:heading) { 'Reset Password' }
    let(:page_title) { 'Reset Password' }
    let(:token) { User.new_remember_token }
      
    describe "with valid token and expiration date" do         
      shared_examples_for "all successfull resets" do
        it { should have_title(name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Sign out', href: signout_path) }        
        it { should have_success_message('Password Reset') }
      end
      
      let(:clan)      { FactoryGirl.create(:clan) }
      let(:user)      { FactoryGirl.create(:user, reset_token: User.encrypt(token), reset_expire: 3.days.from_now) }
      let(:clanuser)  { FactoryGirl.create(:user, clan_id: clan.id, reset_token: User.encrypt(token), reset_expire: 3.days.from_now) } 

      describe "when not in a clan" do
        before { visit reset_password_path(user) + "?token=#{token}" }
        
        it_should_behave_like "all user pages"
        it {should have_content(user.name)}        
        
        describe "with valid information" do
          let(:name) { user.name }
          before do
            fill_in "New Password",     with: user.password
            fill_in "Confirm Password", with: user.password
            click_button "Submit Reset"          
          end  
          
          it_should_behave_like "all successfull resets"              
        end  
          
        describe "with invalid information" do
          before { click_button "Submit Reset" }
  
          it { should have_content('error') }
        end
      end
      
      describe "when in a clan" do
        before { visit reset_password_path(clanuser) + "?token=#{token}" }
        
        it_should_behave_like "all user pages"
        it {should have_content(clanuser.name)}
        
        describe "with valid information" do
          let(:name) { clanuser.name }
          before do
            fill_in "New Password",     with: clanuser.password
            fill_in "Confirm Password", with: clanuser.password
            click_button "Submit Reset"          
          end              
          
          it_should_behave_like "all successfull resets"  
        end
      end        
    end 
    
    describe "with valid token and invalid expiration date" do
      let(:user) { FactoryGirl.create(:user, reset_token: User.encrypt(token), reset_expire: 3.days.ago) }
      
      before { visit reset_password_path(user) + "?token=#{token}" }
      
      it_should_behave_like "bad_reset_request" 
    end 
    
    describe "with invalid token" do
      let(:user) { FactoryGirl.create(:user, reset_token: User.encrypt(token), reset_expire: 3.days.from_now) }
      
      before { visit reset_password_path(user) + "?token=junk" }
      
      it_should_behave_like "bad_reset_request"             
    end
  end
end