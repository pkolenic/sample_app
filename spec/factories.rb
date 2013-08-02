FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    wot_name "Tanker"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end