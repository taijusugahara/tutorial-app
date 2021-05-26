FactoryBot.define do
  factory :user do
    name              { Faker::Name.name }
    email                 { Faker::Internet.free_email  }
    password              { '1a' + Faker::Internet.password(min_length: 4)}
    password_confirmation { password }
  end

  trait :admin do
    admin { true }
  end
end