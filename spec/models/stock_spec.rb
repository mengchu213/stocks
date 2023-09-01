require 'rails_helper'

RSpec.describe Stock, type: :model do
  # Factory
  it "has a valid factory" do
    stock = build(:stock)
    expect(stock).to be_valid
  end

  # Associations
  describe "associations" do
    it { should have_many(:portfolios) }
    it { should have_many(:transactions) }
  end

  # Validations
  describe "validations" do
    subject { build(:stock) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:symbol) }
    it { should validate_presence_of(:current_price) }
    
    it { should validate_numericality_of(:current_price).is_greater_than_or_equal_to(0) }

  end
end
