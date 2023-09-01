FactoryBot.define do
  factory :portfolio, class: Portfolio do
    association :user
    association :stock
    quantity { rand(1..100) }
  end
end
