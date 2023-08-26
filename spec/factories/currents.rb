# spec/factories/currents.rb
FactoryBot.define do
  factory :current, class: Current do
    session { OpenStruct.new(user: create(:user)) }  # Assuming you have a user factory
    user_agent { "Mozilla/5.0" }
    ip_address { "127.0.0.1" }
  end
end
