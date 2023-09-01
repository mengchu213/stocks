FactoryBot.define do
  factory :password_reset_token do
    association :user
  end
end
