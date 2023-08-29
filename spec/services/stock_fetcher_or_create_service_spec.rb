require 'rails_helper'

RSpec.describe StockFetcherOrCreateService do
  let(:symbol) { 'AAPL' }
  subject { described_class.new(symbol).call }

  describe '#call' do
    context 'when stock exists in the database' do
      let!(:existing_stock) { FactoryBot.create(:stock, symbol: symbol) }

      it 'returns the existing stock' do
        expect(subject).to eq(existing_stock)
      end
    end

    context 'when stock does not exist in the database but exists in the external API' do
      before do
        stub_request(:get, "http://phisix-api.appspot.com/stocks/#{symbol}.json")
          .to_return(
            status: 200,
            body: {
              stock: {
                name: "Apple Inc.",
                symbol: symbol,
                price: { amount: 150.0 }
              }
            }.to_json
          )
      end
 
    end

    context 'when stock does not exist in either the database or the external API' do
      before do
        stub_request(:get, "http://phisix-api.appspot.com/stocks/#{symbol}.json")
          .to_return(status: 404)
      end

      it 'does not create a new stock record' do
        expect { subject }.not_to change { Stock.count }
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
