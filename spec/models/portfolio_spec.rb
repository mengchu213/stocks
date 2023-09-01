require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  it "has a valid factory" do
    portfolio = build(:portfolio)
    expect(portfolio).to be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:stock) }
  end

  describe "validations" do
    subject { build(:portfolio) }

    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
