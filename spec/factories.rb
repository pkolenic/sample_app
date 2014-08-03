FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "person_#{n}@example.com"}
    sequence(:name) { |n| "tanker_#{n}"}
    role  UserPending
    active  true
    clan_id 1
    clan_war_team false
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end

    factory :leadership do
      role  UserCompanyCommander
    end
  end

  factory :tournament do
    name "Lorem ipsum Tournament"
    status TournamentForming
    wot_tournament_link "www.somewhere.com"
    wot_team_link "www.somewhere.com/teamlink"
    team_name "Teamname"
    description "This is a Tournament"
    password "pancakes"
    minimum_team_size 3
    maximum_team_size 5
    heavy_tier_limit 3
    medium_tier_limit 3
    td_tier_limit 3
    light_tier_limit 3
    spg_tier_limit 3
    team_maximum_tier_points 9
    victory_conditions "Kill some tanks and stuff"
    schedule "When everyone can't make it"
    prizes "Gold and stuff"
    maps "Only the one noone likes"
    team "2,3,4"
    start_date "2099-08-20 18:30:00".to_datetime
    end_date "2099-12-26 18:30:00".to_datetime
    user
  end
  
  factory :clan do
    sequence(:name)                 { |n| "Clan #{n}" }
    sequence(:clan_short_name)      { |n| "-#{n}-" }
    sequence(:clan_email)           { |n| "clan_#{n}@clans.com" }
    sequence(:wot_clanId)           { |n| "11111#{n}" }
    sequence(:clan_logo)            { |n| "logo-#{n}.png" }
  end
  
  factory :application do
    sequence(:user_id)          { |n| }
    sequence(:clan_id)          { |n| }
  end
end