namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 wot_name: "Example Tanker",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
                 
    99.times do |n|
      name  = Faker::Name.name
      wot_name = "Tanker_#{n+1}"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   wot_name: wot_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 2)
    1.times do
      name = Faker::Lorem.sentence(1)
      users.each { |user| user.tournaments.create!(name: name,
                                                   status: TournamentForming,
                                                   wot_tournament_link: "http://www.somewhere.com",
                                                   wot_team_link: "http://www.somewhere.com/teamlink",
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
    end
  end
end