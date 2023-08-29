# spec/requests/stocks_spec.rb
require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  let!(:user) { create(:user) }
  let!(:stock) { build(:stock, current_price: 100) }

  # Mock authentication before each test
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "GET /stocks" do
    context "when fetching stocks is successful" do
      before do
        allow(FetchStocksService).to receive(:new).and_return(instance_double(FetchStocksService, call: [stock]))
      end

      it "returns http success and fetches stocks" do
        get stocks_path
        expect(response).to have_http_status(:success)
        expect(assigns(:stocks)).to eq([stock])
      end
    end

    context "when fetching stocks fails" do
      before do
        service_instance = instance_double("FetchStocksService")
        allow(FetchStocksService).to receive(:new).and_return(service_instance)
        allow(service_instance).to receive(:call).and_return(nil)
      end
    
      it "sets a flash alert" do
        get stocks_path
        expect(flash[:alert]).to eq("There was an error fetching stocks. Please try again later.")
      end
    end
    
  end

  describe "GET /stocks/:symbol" do
    context "when fetching a specific stock is successful" do
      before do
        allow(PhisixService).to receive(:stock_by_symbol).and_return(stock)
      end

      it "fetches a specific stock" do
        get stock_path(stock.symbol)
        expect(response).to have_http_status(:success)
        expect(assigns(:stock)).to eq(stock)
      end
    end

    context "when fetching a specific stock fails" do
      before do
        allow(PhisixService).to receive(:stock_by_symbol).and_raise("Error")
      end

      it "sets a flash alert and redirects" do
        get stock_path(stock.symbol)
        expect(flash[:alert]).to eq("There was an error fetching the stock details. Please try again later.")
        expect(response).to redirect_to(stocks_path)
      end
    end
  end
end
