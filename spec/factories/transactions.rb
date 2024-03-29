FactoryBot.define do
  factory :transaction do
    association :user
    association :stock
    transaction_type { ['buy', 'sell'].sample }
    quantity { 1 }
    timestamp { Time.now }

    trait :buy do
      transaction_type { 'buy' }
    end

    trait :sell do
      transaction_type { 'sell' }
    end
  end
end
