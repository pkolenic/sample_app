require 'spec_helper'

describe "ClanPages" do

  subject { page }
  
  shared_examples_for "all clan pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Clan Home Page" do
    let(:clan)        { FactoryGirl.create(:clan) }
    let(:clan2)       { FactoryGirl.create(:clan, clan_motto: 'The Best Clan Ever', clan_google_plus_id: '12345',     
                                                    clan_requirements: 'You must do this',
                                                    clan_about: 'We are about' )}       
    describe "when optional values set" do
      let(:heading)         { "[#{clan2.clan_short_name}] #{clan2.name}" }
      let(:page_title)      { clan2.name }
               
      before  { visit clan_path(clan2) }
        
      it_should_behave_like 'all clan pages'  
      it { should have_selector('h2', text: clan2.clan_motto) }
      it { should have_link("Google+") }
      it { should have_selector('li', text: 'About') }
      it { should have_selector('li', text: 'Requirements') }
      it { should have_selector('div#about-tab-body') }
      it { should have_selector('div#requirements-tab-body', :visible=>false) }
    end
        
    describe "when optional values not set" do
      let(:heading)         { "[#{clan.clan_short_name}] #{clan.name}" }
      let(:page_title)      { clan.name }      
      
      before  { visit clan_path(clan) }
        
      it_should_behave_like 'all clan pages'
      it { should_not have_selector('h2') }
      it { should_not have_link("Google+") }
      it { should_not have_selector('li', text: 'About') }
      it { should_not have_selector('li', text: 'Requirements') }
      it { should_not have_selector('div#about-tab-body') }
      it { should_not have_selector('div#requirements-tab-body') }            
    end    
          
    describe "when current user in the clan" do
      let(:user) { FactoryGirl.create(:user, clan_id: clan.id) }
        
      before do 
        sign_in user
        visit clan_path(clan)
      end
        
      it { should_not have_selector('div#default_home_body') }
      it { should_not have_link("Join the Clan", href: signup_path(:clan_id => clan.slug)) }
      it { should have_selector('div#teamspeak_box') }
    end
      
    describe "when current user not in the clan" do
      let(:user)  { FactoryGirl.create(:user, clan_id: clan2.id) }
      
      before do
        sign_in user
        visit clan_path(clan)
      end
          
      it { should have_selector('div#default_home_body') }
      it { should have_link("Join the Clan", href: signup_path(:clan_id => clan.slug)) }   
      it { should_not have_selector('div#teamspeak_box') }
        
      describe "when clicking on Join The Clan Link" do
        before { click_link "Join the Clan" }
          
        it { should have_title(full_title("Apply | #{clan.name}")) }
      end
    end
        
    describe "when no current user" do
      before            { visit clan_path(clan) }
               
      it { should have_selector('h1', text: clan.name) }
      it { should have_title(full_title(clan.name)) }      
      it { should have_selector('div#default_home_body') }
      it { should have_link("Join the Clan", href: signup_path(:clan_id => clan.slug)) }
      it { should_not have_selector('div#teamspeak_box') }
        
      describe "when clicking on Join The Clan Link" do
        before { click_link "Join the Clan" }
          
        it { should have_title(full_title("Apply | #{clan.name}")) }
      end     
    end
  end

  describe "Clan Admin Panel" do
    let!(:clan)             { FactoryGirl.create(:clan) }
    let!(:clan2)            { FactoryGirl.create(:clan) }
    let!(:admin_privilege)  { FactoryGirl.create(:privilege, name: CLAN_ADMIN) }
    let!(:user)             { FactoryGirl.create(:user, clan_id: clan.id) }
    
    describe "as non clan admin" do
      before do
         sign_in user
         visit clan_admin_path(clan)
      end
      
      specify { current_url.should eq clan_url(clan) }
      it { should have_error_message('Only clan admins can visit the admin panel!') }
    end
    
    describe "as clan admin" do
      before do
        user.user_privileges.create!(privilege_id: admin_privilege.id)
        sign_in user
      end
      
      describe "for another clan" do
        before { visit clan_admin_path(clan2) }
        
        specify { current_url.should eq clan_url(clan2) }
        it { should have_error_message('You can only visit the admin panel for your clan!') }
      end
      
      describe "for the current clan" do
        let(:heading)         { "#{clan.name } Admin Panel" }
        let(:page_title)      { "Admin Panel" }
        let(:total_tankers)       { User.where('clan_id = ?', clan.id).count }
        let(:registered_tankers)  { User.where("active = ? AND clan_id = '#{clan.id}'", true).count }
        let(:inactive_tankers)    { User.where("clan_id = ? AND last_online < '#{Time.now - 30.days}'", clan.id).count }
    
        before { visit clan_admin_path(clan) }
        
        specify { current_url.should eq clan_admin_url(clan) }
        
        it_should_behave_like 'all clan pages'    
        it { should have_selector('h2', text: 'Clan Statistics') }
        it { should have_selector('h2', text: 'Customizations') }
        
        # Stats
        it { should have_selector('span', text: 'Total Tankers') }
        it { should have_selector('span', text: "#{total_tankers}") }
        
        it { should have_selector('span', text: 'Registered Tankers') }
        it { should have_selector('span', text: "#{registered_tankers}") }
        
        it { should have_selector('span', text: 'Inactive Tankers') }
        it { should have_selector('span', text: "#{inactive_tankers}") }
        
        # Links
        it { should have_link("Video Pages", href: clan_videos_path(clan)) }
        it { should have_link("Customize Clan Pages", href: "#") }
      end
    end 
  end
  
  describe "Admin Panel Link" do
    let!(:clan)             { FactoryGirl.create(:clan) }
    let!(:clan2)            { FactoryGirl.create(:clan) }
    let!(:admin_privilege)  { FactoryGirl.create(:privilege, name: CLAN_ADMIN) }
    let!(:user)             { FactoryGirl.create(:user, clan_id: clan.id) }    
    
    describe "as non clan admin" do
      before { sign_in user }
      
      describe "on clan page" do
        before { visit clan_path(clan) }
        it { should_not have_link("Admin Panel", href: clan_admin_path(clan)) }
      end      
      
      describe "on another clan page" do
        before { visit clan_path(clan2) }
        it { should_not have_link("Admin Panel", href: clan_admin_path(clan2)) }        
      end
    end
    
    describe "as clan admin" do
      before do
        user.user_privileges.create!(privilege_id: admin_privilege.id)
        sign_in user
      end
      
      describe "on clan page" do
        before { visit clan_path(clan) }
        it { should have_link("Admin Panel", href: clan_admin_path(clan)) }
      end
      
      describe "on another clan page" do
        before { visit clan_path(clan2) }
        it { should_not have_link("Admin Panel", href: clan_admin_path(clan2)) }              
      end
    end
  end
end
