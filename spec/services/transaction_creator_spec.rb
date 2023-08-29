require 'rails_helper'

RSpec.describe TransactionCreatorService do
  let(:user) { FactoryBot.create(:user) }
  let(:stock) { FactoryBot.create(:stock) }
  let(:transaction_params) { { transaction_type: 'buy', quantity: 5 } }
  subject { described_class.new(user, stock, transaction_params).call }

  describe '#call' do
    it 'returns a new transaction instance' do
      expect(subject).to be_a_new(Transaction)
    end

    it 'associates the transaction with the user' do
      expect(subject.user).to eq(user)
    end

    it 'associates the transaction with the stock' do
      expect(subject.stock).to eq(stock)
    end

    it 'sets the transaction attributes correctly' do
      expect(subject.transaction_type).to eq('buy')
      expect(subject.quantity).to eq(5)
    end

    it 'sets the timestamp to the current time' do
      time_now = Time.parse("2023-07-28 12:00:00 UTC")
      allow(Time).to receive(:now).and_return(time_now)
      expect(subject.timestamp).to eq(time_now)
    end
  end
end
