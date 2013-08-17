require 'spec_helper'

describe "User pages" do

  subject { page }

  shared_examples_for "all user pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end
  
  shared_examples_for "should promote recruit" do
    before do        
      tanker.update_attribute(:role, UserRecruit)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }    
  end
  
  shared_examples_for "should promote soldier" do
    before do        
      tanker.update_attribute(:role, UserSoldier)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }            
  end
  
  shared_examples_for "should promote treasurer" do
    before do        
      tanker.update_attribute(:role, UserTreasurer)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should promote recruiter" do
    before do        
      tanker.update_attribute(:role, UserRecruiter)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end

  shared_examples_for "should promote diplomat" do
    before do        
      tanker.update_attribute(:role, UserDiplomat)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
    
  shared_examples_for "should promote company commander" do
    before do        
      tanker.update_attribute(:role, UserCompanyCommander)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should promote deputy commander" do
    before do        
      tanker.update_attribute(:role, UserDeputyCommander)
      tanker.reload.role
      visit users_path
    end

    it { should have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should not promote pending" do
    before { visit users_path }
    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }
  end
  
  shared_examples_for "should not promote soldier" do
    before do        
      tanker.update_attribute(:role, UserSoldier)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }     
  end
  
  shared_examples_for "should not promote treasurer" do
    before do        
      tanker.update_attribute(:role, UserTreasurer)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end

  shared_examples_for "should not promote recruiter" do
    before do        
      tanker.update_attribute(:role, UserRecruiter)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
    
  shared_examples_for "should not promote diplomat" do
    before do        
      tanker.update_attribute(:role, UserDiplomat)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should not promote company commander" do
    before do        
      tanker.update_attribute(:role, UserCompanyCommander)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should not promote deputy commander" do
    before do        
      tanker.update_attribute(:role, UserDeputyCommander)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end
  
  shared_examples_for "should not promote commander" do
    before do        
      tanker.update_attribute(:role, UserCommander)
      tanker.reload.role
      visit users_path
    end

    it { should_not have_link('promote/demote', href: edit_promotion_path(tanker)) }      
  end

  describe "index" do
    
    let(:heading) { 'Battle Roster' }
    let(:page_title) { 'Battle Roster' }
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end
  
    it_should_behave_like "all user pages"
    
    describe "pagination" do

      before(:all) { 15.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1, :per_page => 10).order(:id).each do |user|
          expect(page).to have_selector('li', text: user.wot_name)
        end
      end
    end
    
    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end   
    
    describe "approve links" do
      it { should_not have_link('approve') }
      
      describe "as clan leadership" do
        let(:leadership) { FactoryGirl.create(:leadership) }
        let(:valid_tanker) { FactoryGirl.create(:user, wot_name: "valid") } 
        let(:invalid_tanker) { FactoryGirl.create(:user, wot_name: "a") }
        before do
          User.delete_all
          valid_tanker = FactoryGirl.create(:user, wot_name: "valid") 
          invalid_tanker = FactoryGirl.create(:user, wot_name: "a")
          leadership = FactoryGirl.create(:leadership)
          leadership.update_attribute(:role, UserRecruiter)
          sign_in leadership
          visit "#{users_path}?type=pending"
        end
        after{ 15.times { FactoryGirl.create(:user) } }
        
        it { should have_link('approve', href: approve_path(User.first)) }
        it { should_not have_link('approve', href: approve_path(leadership)) }
        it { should have_content("#{invalid_tanker.wot_name} is not a valid World of Tanks user") }
        it { should_not have_content("#{valid_tanker.wot_name} is not a valid World of Tanks user") }
        
        describe "should be able to approve another user" do
          before { click_link('approve', match: :first) }
          specify { expect(User.first).to be_active_member }
          specify { expect(ActionMailer::Base.deliveries.last.to).to eq [User.first.email] }
        end
      end
    end
  end
  
 describe "promote links" do
    let(:tanker ) { FactoryGirl.create(:user) }   
    let(:leadership) { FactoryGirl.create(:user) }
    
    describe "as Company Commander" do
      before do
        leadership.update_attribute(:role, UserCompanyCommander)
        leadership.reload.role
        sign_in leadership
      end

      it { should_not have_link('promote', href: edit_promotion_path(leadership)) }
      it_should_behave_like "should not promote pending"
      it_should_behave_like "should promote recruit"
      it_should_behave_like "should promote soldier"
      it_should_behave_like "should not promote treasurer"
      it_should_behave_like "should not promote recruiter"
      it_should_behave_like "should not promote diplomat"
      it_should_behave_like "should not promote company commander"
      it_should_behave_like "should not promote deputy commander"
      it_should_behave_like "should not promote commander"
    end
    
    describe "as Deputy Commander" do
      before do
        leadership.update_attribute(:role, UserDeputyCommander)
        leadership.reload.role
        sign_in leadership
      end
      
      it { should_not have_link('promote', href: edit_promotion_path(leadership)) }
      it_should_behave_like "should not promote pending"
      it_should_behave_like "should promote recruit"
      it_should_behave_like "should promote soldier"
      it_should_behave_like "should promote treasurer"
      it_should_behave_like "should promote recruiter"
      it_should_behave_like "should promote diplomat"
      it_should_behave_like "should promote company commander"
      it_should_behave_like "should not promote deputy commander"
      it_should_behave_like "should not promote commander"       
    end
    
    describe "as Commander" do
      before do
        leadership.update_attribute(:role, UserCommander)
        leadership.reload.role
        sign_in leadership
      end
      
      it { should_not have_link('promote', href: edit_promotion_path(leadership)) }
      it_should_behave_like "should not promote pending"
      it_should_behave_like "should promote recruit"
      it_should_behave_like "should promote soldier"
      it_should_behave_like "should promote treasurer"
      it_should_behave_like "should promote recruiter"
      it_should_behave_like "should promote diplomat"
      it_should_behave_like "should promote company commander"
      it_should_behave_like "should promote deputy commander"
      it_should_behave_like "should not promote commander"      
    end
  end 

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:heading)    { user.wot_name }
    let(:page_title) { user.wot_name }
    before { visit user_path(user) }

    it_should_behave_like "all user pages"
  end

  describe "signup page" do
    let(:heading)    { 'Sign up' }
    let(:page_title) { 'Sign up' }
    before { visit signup_path }

    it_should_behave_like "all user pages"
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in_user_form }
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.wot_name) }
        it { should have_success_message('Welcome') }
      end
    end
  end
  
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
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(user.wot_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
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
end