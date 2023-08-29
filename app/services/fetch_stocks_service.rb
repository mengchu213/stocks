class FetchStocksService
  attr_reader :query, :page

  def initialize(query: nil, page: 1)
    @query = query&.strip&.downcase
    @page = page
  end

  def call
    all_stocks = PhisixService.all_stocks['stock']
    filtered_stocks = if query.present?
      all_stocks.select do |stock|
        stock['name'].downcase.include?(query) || stock['symbol'].downcase.include?(query)
      end
    else
      all_stocks
    end

    Kaminari.paginate_array(filtered_stocks).page(page).per(10)
  
  end
end
