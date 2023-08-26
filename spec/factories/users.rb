# spec/factories/users.rb

FactoryBot.define do
  sequence(:user_email) { |n| "testuser#{n}@example.com" } # To ensure unique email

  factory :user do
    email { generate(:user_email) }
    password { "password123" } 
    password_confirmation { "password123" } # Since `has_secure_password` is used
    role { ["Trader", "Admin"].sample }
    status { ["Pending", "Approved"].sample }
    verified { [true, false].sample }
    balance { rand(1000..5000).to_f.round(2) } # Generates a random float between 1000 and 5000

    # Optional: If you want to create associations (like transactions, portfolios etc.) with the user.
    # after(:create) do |user|
    #   create_list(:transaction, 3, user: user) # assuming you have a transaction factory
    #   create_list(:portfolio, 3, user: user)   # assuming you have a portfolio factory
    # end
  end
end
