FactoryBot.define do
  factory :stock do
    name { "Apple Inc." }
    symbol { "AAPL" }
    current_price { 150.0 }

    trait :invalid do
      name { nil }
      symbol { nil }
      current_price { nil }
    end
  end
end
