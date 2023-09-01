FactoryBot.define do
  factory :email_verification_token do
    association :user
  end
end
