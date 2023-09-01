FactoryBot.define do
  sequence(:user_email) { |n| "testuser#{n}@example.com" }

  factory :user do
    email { generate(:user_email) }
    password { "password123" }
    password_confirmation { "password123" }
    role { ["Trader", "Admin"].sample }
    status { "Approved" }
    verified { [true, false].sample }
    balance { rand(1000..5000).to_f.round(2) }

    trait :pending do
      status { "Pending" }
    end

    trait :approved do
      status { "Approved" }
    end

    trait :trader do
      role { "Trader" }
    end

    trait :admin do
      role { "Admin" }
    end

    trait :verified do
      verified { true }
    end

    trait :unverified do
      verified { false }
    end
  end
end
