# spec/factories/stocks.rb
FactoryBot.define do
  factory :stock do
    name { "Apple Inc." }
    symbol { "AAPL" }
    current_price { 150.0 }
  end
end
