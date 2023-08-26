# spec/models/transaction_spec.rb

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    let(:user) { create(:user, balance: 1000.0) }
    let(:stock) { create(:stock, current_price: 100.0) }

    it "is valid with valid attributes" do
      transaction = build(:transaction, user: user, stock: stock)
      expect(transaction).to be_valid
    end

    it "is not valid without a transaction type" do
      transaction = build(:transaction, transaction_type: nil)
      expect(transaction).not_to be_valid
    end

    it "is not valid with invalid transaction type" do
      transaction = build(:transaction, transaction_type: "invalid_type")
      expect(transaction).not_to be_valid
    end

    it "is not valid with a quantity less than or equal to 0" do
      transaction = build(:transaction, quantity: 0)
      expect(transaction).not_to be_valid
    end

    it 'is not valid without a stock current price' do
      stock = build(:stock, current_price: nil)
      transaction = build(:transaction, stock: stock)
      transaction.valid? # This triggers the custom validation
      
      expect(transaction.errors[:base]).to include("Stock doesn't have a current price")
    end
    
    

    it "is not valid if user doesn't have sufficient funds" do
      transaction = build(:transaction, user: user, stock: stock, quantity: 20) # This would need $2000
      expect(transaction).not_to be_valid
      expect(transaction.errors.messages[:base]).to include("Insufficient funds")
    end
  end

  describe 'associations' do
    let(:user) { create(:user) }
    let(:stock) { create(:stock) }

    subject { build(:transaction, user: user, stock: stock) }  # build the transaction with the user and stock

    it { should belong_to(:user).required(true) }
    it { should belong_to(:stock).required(true) }
  end

  describe "#process_transaction" do
    let(:user) { create(:user, balance: 1000.0) }
    let(:stock) { create(:stock, current_price: 100.0) }

    it "deducts the cost of the stock from the user's balance" do
      transaction = create(:transaction, user: user, stock: stock, quantity: 5)
      transaction.process_transaction
      user.reload
      expect(user.balance).to eq(500.0) # $1000 - (5 * $100)
    end
  end
end
