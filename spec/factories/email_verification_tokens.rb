# spec/factories/email_verification_tokens.rb
FactoryBot.define do
  factory :email_verification_token do
    association :user
  end
end
