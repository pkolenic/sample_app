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
  end
end