require 'rails_helper'

RSpec.describe TransactionService do
  let(:user) { FactoryBot.create(:user, balance: 10_000) } 
  let(:stock) { FactoryBot.create(:stock, current_price: 100) } 
  let(:transaction) { FactoryBot.build(:transaction, stock: stock, quantity: 5, transaction_type: transaction_type) }
  subject { described_class.new(user, transaction).process }

  describe 'buying stocks' do
    let(:transaction_type) { 'buy' }

    it 'deducts the correct amount from the user balance' do
      expect { subject }.to change { user.reload.balance }.by(-500)
    end

    
    
  end

  describe 'selling stocks' do
    let(:transaction_type) { 'sell' }

    before do
      FactoryBot.create(:portfolio, user: user, stock: stock, quantity: 10)
    end

    it 'adds the correct amount to the user balance' do
      expect { subject }.to change { user.reload.balance }.by(500)
    end

    
  end
end
