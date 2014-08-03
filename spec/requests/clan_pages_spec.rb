require 'spec_helper'

describe "ClanPages" do

  subject { page }

  describe "Clan Home Page" do
    describe "clan page" do
      let(:clan)        { FactoryGirl.create(:clan) }
      let(:clan2)       { FactoryGirl.create(:clan, clan_motto: 'The Best Clan Ever', clan_google_plus_id: '12345',     
                                                    clan_requirements: 'You must do this',
                                                    clan_about: 'We are about' )}       
      describe "when optional values set" do   
        before            { visit clan_path(clan2) }
        
        it { should have_selector('h2', text: clan2.clan_motto) }
        it { should have_link("Google+") }
        it { should have_selector('li', text: 'About') }
        it { should have_selector('li', text: 'Requirements') }
        it { should have_selector('div#about-tab-body') }
        it { should have_selector('div#requirements-tab-body', :visible=>false) }
      end
        
      describe "when optional values not set" do
        before            { visit clan_path(clan) }
        
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
  end
end
