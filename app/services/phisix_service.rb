
require 'httparty'

class PhisixService
  BASE_URL = 'http://phisix-api.appspot.com/'

  def self.all_stocks(format = 'json')
    HTTParty.get("#{BASE_URL}stocks.#{format}")
  end

  def self.stock_by_symbol(symbol, format = 'json', date = nil)
    if date
      HTTParty.get("#{BASE_URL}stocks/#{symbol}.#{date}.#{format}")
    else
      HTTParty.get("#{BASE_URL}stocks/#{symbol}.#{format}")
    end
  end
end
