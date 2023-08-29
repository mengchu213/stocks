require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /sign_up" do
    it "renders the new registration page" do
      get sign_up_path

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /sign_up" do
    context "with valid attributes" do
      let(:user_attributes) do 
        attributes_for(:user, email: "testuser47@example.com", password: 'password123', password_confirmation: 'password123', role: "Trader", status: "Pending", verified: false, balance: 100.0)
      end
    
      
    end
    
    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:user, email: "", password: 'password123', password_confirmation: 'password123') }

      it "does not create a new user and renders the new registration page" do
        expect {
          post sign_up_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
