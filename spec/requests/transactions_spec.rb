require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let!(:admin) { create(:user, role: 'Admin') }
  let!(:user) { create(:user, role: 'Trader') }
  let!(:stock) { create(:stock) }
  let!(:transaction1) { create(:transaction, user: user) }
  let!(:transaction2) { create(:transaction, user: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe "GET /transactions" do
    context "when user is Admin" do
      before do
        allow(Current).to receive(:user).and_return(admin)
      end

      it "lists all transactions" do
        get user_transactions_path(user.id)

        expect(response).to have_http_status(:success)
        expect(assigns(:transactions).count).to eq(2)
      end
    end

    context "when user is Trader" do
      before do
        allow(Current).to receive(:user).and_return(user)
      end

      it "lists transactions for the current user" do
        get user_transactions_path(user.id)

        expect(response).to have_http_status(:success)
        expect(assigns(:transactions).count).to eq(2)
      end
    end
  end

  describe "GET /stocks/:stock_symbol/transactions/new" do
    it "sets up a new transaction" do
      get new_stock_transaction_path(stock.symbol)

      expect(response).to have_http_status(:success)
      expect(assigns(:transaction)).to be_a_new(Transaction)
    end
  end

  describe "POST /stocks/:stock_symbol/transactions" do
    before do
      allow(Current).to receive(:user).and_return(user)
    end

    context "with valid params" do
      it "creates a new transaction" do
        expect {
          post stock_transactions_path(stock.symbol), params: { transaction: { transaction_type: "buy", quantity: 10 } }

        }.to change(Transaction, :count).by(1)
        
        expect(response).to redirect_to(stocks_path)
      end
    end

    context "with invalid params" do
      it "fails to create a transaction" do
        post stock_transactions_path(stock.symbol), params: { transaction: { transaction_type: "Buy", quantity: '' } }

        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end

    context "with invalid stock symbol" do
      it "fails to create a transaction" do
        post stock_transactions_path("INVALID"), params: { transaction: { transaction_type: "Buy", quantity: 10 } }

        expect(response).to redirect_to(new_stock_transaction_path(stock_symbol: "INVALID"))
        expect(flash[:alert]).to eq("Stock with symbol INVALID could not be fetched or created.")
      end
    end
  end
end
