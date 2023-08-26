class StockFetcherOrCreateService
  def initialize(symbol)
    @symbol = symbol.upcase
  end

  def call
    stock = Stock.find_by(symbol: @symbol)

    return stock if stock

    fetched_stock_data = fetch_stock_from_external_source
    return unless fetched_stock_data

    Stock.create(
      name: fetched_stock_data[:name], 
      symbol: fetched_stock_data[:symbol],
      current_price: fetched_stock_data[:current_price]
    )
  end

  private

  def fetch_stock_from_external_source
    response = HTTParty.get("http://phisix-api.appspot.com/stocks/#{@symbol}.json")

    if response.success?
      stock_data = response.parsed_response["stock"].first  
      {
        name: stock_data["name"],
        symbol: stock_data["symbol"],
        current_price: stock_data["price"]["amount"]
      }
    else
      nil
    end
  end
end
