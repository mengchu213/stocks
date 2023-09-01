require 'rails_helper'

describe PhisixService do
  describe '.all_stocks' do
    before do
      stub_request(:get, "http://phisix-api.appspot.com/stocks.json").
        to_return(body: '{"stocks":"stocks"}') 
    end

    it 'fetches all stocks' do
      result = PhisixService.all_stocks
      expect(result['stocks']).to eq('stocks') 
    end
  end

  describe '.stock_by_symbol' do
    before do
      stub_request(:get, "http://phisix-api.appspot.com/stocks/sample_symbol.json").
        to_return(body: '{"stock":"stock"}')  
    end

    it 'fetches a stock by its symbol' do
      result = PhisixService.stock_by_symbol("sample_symbol")
      expect(result['stock']).to eq('stock') 
    end
  end
end
