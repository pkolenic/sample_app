include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    valid_signin user
  end
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def fill_in_user_form
  fill_in "user_name",        with: "Tanker"
  fill_in "Email",            with: "user@example.com"
  fill_in "Password",         with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end

def fill_in_user_form_with_user(user, clan)
  fill_in "user_name",         with: user.name
  fill_in "Email",             with: user.email
  fill_in "Password",          with: user.password
  fill_in "Confirm Password",  with: user.password
  if clan
    select clan.name,          from: "user[clan_id]", :match => :first
  end
end

def fill_in_tournament_form
  fill_in "Name",                                     with: "Lorem ipsum Tournament"
  fill_in "Official World of Tank Tournament Link",   with: "www.somewhere.com"
  fill_in "Official World of Tank Team Link",         with: "www.somewhere.com/teamlink"
  fill_in "Team Name",                                with: "Teamname"
  fill_in "Tournament Description",                   with: "<p>With a description</p>"
  select "3",                                         from: "tournament[minimum_team_size]"
  select "5",                                         from: "tournament[maximum_team_size]"
  select "5",                                         from: "tournament[heavy_tier_limit]"
  select "5",                                         from: "tournament[medium_tier_limit]"
  select "5",                                         from: "tournament[td_tier_limit]"
  select "5",                                         from: "tournament[light_tier_limit]"
  select "5",                                         from: "tournament[spg_tier_limit]"
  fill_in "Team Maximum Tier Points",                 with: "9"
  fill_in "Victory Conditions",                       with: "Kill some tanks and stuff"
  fill_in "Schedule",                                 with: "When everyone can't make it"
  fill_in "Prizes",                                   with: "Gold and stuff"
  fill_in "Maps",                                     with: "Only the one noone likes"
  fill_in "Start Date",                               with: "2099-08-20 18:30:00"
  fill_in "End Date",                                 with: "2099-12-26 18:30:00"    
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end

RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end
