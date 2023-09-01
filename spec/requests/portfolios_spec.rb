require 'rails_helper'

RSpec.describe "Portfolios", type: :request do
  let!(:user) { create(:user) }
  let!(:stock1) { create(:stock) }
  let!(:stock2) { create(:stock) }
  let!(:portfolio1) { create(:portfolio, user: user, stock: stock1, quantity: 5) }
  let!(:portfolio2) { create(:portfolio, user: user, stock: stock2, quantity: 10) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "GET /index" do
    it "lists portfolios for the current user" do
      get portfolios_path

      expect(response).to have_http_status(:success)
      expect(assigns(:portfolios).count).to eq(2)
      expect(assigns(:all_portfolios).count).to eq(2)
    end
  end
end
