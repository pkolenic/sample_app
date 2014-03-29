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
  
  factory :rune do
    name "Test Rune"
    translation "The translation"
    level 1
    quality_id 1
    rune_type_id 1
  end
  
  factory :aspect_rune do
    name "Ta"
    translation "Base"
    level 1
    quality_id 1  
  end
  
  factory :essence_rune do
    name "Dekeipa"
    translation "Frost"
  end
  
  factory :potency_rune do
    name "Jora"
    translation "Develop"
    level 1
    glyph_prefix_id 1
    gear_level_id 1
  end
  
  factory :glyph_prefix do
    name "Trifling"
  end
  
  factory :gear_level do
    name "Level 1—10"
  end
  
  factory :title do
    name "SkyShards"
    region "The Daggerfall Covenant"
  end
  
  factory :rank do
    title "Pending"
  end
  
  factory :quality do
    name "Normal"
    color "White"
  end
  
  factory :rune_type do
    name "Aspect"
  end
end
