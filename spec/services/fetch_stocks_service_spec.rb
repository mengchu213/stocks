# spec/services/fetch_stocks_service_spec.rb
require 'rails_helper'

RSpec.describe FetchStocksService do
  describe '#call' do
    let(:query) { nil }
    let(:page) { 1 }
    let(:service) { FetchStocksService.new(query: query, page: page) }
    let(:stock_data) do
      {
        'stock' => [
          {'name' => 'SampleStock', 'symbol' => 'SS'},
          {'name' => 'AnotherStock', 'symbol' => 'AS'},
          # ... add more sample stocks as needed
        ]
      }
    end

    before do
      allow(PhisixService).to receive(:all_stocks).and_return(stock_data)
    end

    it 'returns all stocks if no query is provided' do
      expect(service.call).to eq(stock_data['stock'])
    end

    context 'with a query' do
      let(:query) { 'sample' }

      it 'returns only the stocks that match the query' do
        expect(service.call).to contain_exactly(stock_data['stock'].first)
      end
    end

    # Add more contexts or examples as needed...
  end
end
