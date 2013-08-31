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
  fill_in "Name",             with: "Example User"
  fill_in "user_wot_name",    with: "Tanker"
  fill_in "Email",            with: "user@example.com"
  fill_in "Password",         with: "foobar"
  fill_in "Confirm Password", with: "foobar"
end

def fill_in_tournament_form
  fill_in "Name",                       with: "Lorem ipsum Tournament"
  fill_in "wot_tournament_link",        with: "www.somewhere.com"
  fill_in "www.somewhere.com/teamlink", with: "www.somewhere.com/teamlink"
  fill_in "team_name",                  with: "Teamname"
  fill_in "description",                with: "<p>With a description</p>"
  select "3",                           from: "tournament[minimum_team_size]"
  select "5",                           from: "tournament[maximum_team_size]"
  select "5",                           from: "tournament[heavy_tier_limit]"
  select "5",                           from: "tournament[medium_tier_limit]"
  select "5",                           from: "tournament[td_tier_limit]"
  select "5",                           from: "tournament[light_tier_limit]"
  select "5",                           from: "tournament[spg_tier_limit]"
  fill_in "team_maximum_tier_points",   with: "9"
  fill_in "victory_conditions",         with: "Kill some tanks and stuff"
  fill_in "schedule",                   with: "When everyone can't make it"
  fill_in "prizes",                     with: "Gold and stuff"
  fill_in "maps",                       with: "Only the one noone likes"
  fill_in "start_date",                 with: "2099-08-20 18:30:00"
  fill_in "end_date",                   with: "2099-12-26 18:30:00"    
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
