# spec/factories/password_reset_tokens.rb
FactoryBot.define do
  factory :password_reset_token do
    association :user
  end
end
