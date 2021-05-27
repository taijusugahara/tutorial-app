FactoryBot.define do
  factory :user do
    name              { Faker::Name.name }
    email                 { Faker::Internet.free_email  }
    password              { '1a' + Faker::Internet.password(min_length: 4)}
    password_confirmation { password }
    # 下の二つは後で改良
    activated {true}
    activated_at {Time.zone.now}
  end

  trait :admin do
    admin { true }
  end

  trait :not_activation do
    activated {false}
    activated_at {nil}
  end

end