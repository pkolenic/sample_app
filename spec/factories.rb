FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  
  factory :event do
    title "Event Title"
    deck "Event description"
    start_time "2014-03-10 10:00:00"
    end_time "2014-03-10 10:00:05"
    public true
    user
  end
end
