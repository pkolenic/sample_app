namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
                 
    30.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    15.times do |n|
      title = Faker::Lorem.sentence(2)
      deck = Faker::Lorem.sentence(5)
      start_time = (n + 2).hour.ago
      end_time = n.hour.ago
      users.each { |user| user.events.create!(title: title, 
                                              deck: deck,
                                              start_time: start_time,
                                              end_time: end_time) }
    end    
  end
end