require 'httparty'

class PhisixService
  BASE_URL = 'http://phisix-api.appspot.com/'

  def self.all_stocks(format = 'json')
    response = HTTParty.get("#{BASE_URL}stocks.#{format}")
    response.parsed_response
  end

  def self.stock_by_symbol(symbol, format = 'json', date = nil)
    if date
      response = HTTParty.get("#{BASE_URL}stocks/#{symbol}.#{date}.#{format}")
    else
      response = HTTParty.get("#{BASE_URL}stocks/#{symbol}.#{format}")
    end
    response.parsed_response
  end
end
