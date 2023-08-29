# spec/helpers/portfolios_helper_spec.rb
require 'rails_helper'

RSpec.describe PortfoliosHelper, type: :helper do
  describe "#total_stocks_value" do
    let(:stock1) { create(:stock, current_price: 100) }
    let(:stock2) { create(:stock, current_price: 200) }
    let(:portfolios) do
      [
        create(:portfolio, stock: stock1, quantity: 2),
        create(:portfolio, stock: stock2, quantity: 3)
      ]
    end

    it "returns the total value of all stocks in portfolios" do
      expect(helper.total_stocks_value(portfolios)).to eq(800) # (2 * 100) + (3 * 200)
    end
  end

  describe "#portfolios_empty?" do
    context "when portfolios is empty" do
      let(:portfolios) { [] }

      it "returns true" do
        expect(helper.portfolios_empty?(portfolios)).to be true
      end
    end

    context "when portfolios is not empty" do
      let(:portfolios) { [create(:portfolio)] }

      it "returns false" do
        expect(helper.portfolios_empty?(portfolios)).to be false
      end
    end
  end
  
  describe "#total_balance" do
    let(:user_balance) { 1000 }
    let(:total_stocks_value) { 500 }

    it "returns the total balance summing user balance and total stocks value" do
      expect(helper.total_balance(user_balance, total_stocks_value)).to eq(1500)
    end
  end
end
