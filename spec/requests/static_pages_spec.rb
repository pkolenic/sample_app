require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Fear The Fallen' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
    
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title(full_title(''))
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "logo"
    expect(page).to have_title(full_title(''))
    click_link "Sign in"
    expect(page).to have_title(full_title('Sign in'))
  end
  
  describe "tournament links show" do
    let(:user) { FactoryGirl.create(:user, role: UserSoldier) }
    let!(:t1) { FactoryGirl.create(:tournament, user: user, name: "Foo") }
    let!(:t2) { FactoryGirl.create(:tournament, user: user, name: "Bar") }
        
    before { sign_in user }
    
    it { should have_link('Tournaments') }
    it { should have_link('<Create New Tournament>')}
    it { should have_link('Foo') }
    it { should have_link('Bar') }
  end
  
  describe "tournament links do not show" do
    let(:user) { FactoryGirl.create(:user, role: UserRecruit) }
    let!(:t1) { FactoryGirl.create(:tournament, user: user, name: "Foo") }
    let!(:t2) { FactoryGirl.create(:tournament, user: user, name: "Bar") }
    
    before { sign_in user }
    
    it { should_not have_link('Tournaments') }
    it { should_not have_link('<Create New Tournament>')}
    it { should_not have_link('Foo') }
    it { should_not have_link('Bar') } 
  end
end