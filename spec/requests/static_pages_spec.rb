require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { ALLIANCE_NAME }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
    it { should_not have_selector('div#teamspeak_box') }
    
    describe "when current user" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user
        visit root_path
      end
      
      it { should_not have_selector('div#teamspeak_box') }
      it { should_not have_link("Join #{ALLIANCE_NAME}", href: signup_path) }
    end
    
    describe "when no user" do
      it { should have_link("Join #{ALLIANCE_NAME}", href: signup_path) }
      
      it "should go to signup page when link clicked" do
        click_link"Join #{ALLIANCE_NAME}"
        expect(page).to have_title(full_title("Signup"))
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it { should_not have_selector('div#teamspeak_box') }
    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }

    it { should_not have_selector('div#teamspeak_box') }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it { should_not have_selector('div#teamspeak_box') }
    it_should_behave_like "all static pages"
  end
    
  # TODO there shouldn't be a Schedule except on Clan Pages     
  describe "Schedule page" do
    before { visit schedule_path }
    let(:page_title)  { 'Schedule' }
    
    it { should_not have_selector('div#teamspeak_box') }
    it { should have_title(full_title(page_title)) }
  end  
    
  it "should have the right links on the layout" do
    # TODO - Need to check that all links are present for the Header and Footer
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Join #{ALLIANCE_NAME}"
    expect(page).to have_title(full_title("Signup"))
    click_link "logo"
    expect(page).to have_title(full_title(''))
    click_link "Sign in"
    expect(page).to have_title(full_title('Sign in'))
  end
    
end