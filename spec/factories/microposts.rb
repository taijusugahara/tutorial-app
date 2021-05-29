FactoryBot.define do
  
  factory :micropost do
    content { Faker::Lorem.sentence }
    # created_at { 10.minutes.ago }
    association :user
    
  end

  trait :yesterday do
    content { "昨日" }
    created_at { 1.day.ago }
  end

  trait :now do
    content { "今" }
    created_at { Time.zone.now }
  end

  trait :one_week_ago do
    content { "１週間前" }
    created_at { 1.week.ago }
  end


end
