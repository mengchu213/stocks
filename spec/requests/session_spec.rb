require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user, status: "Approved", password: 'password123', password_confirmation: 'password123') }
  def sign_in(user)
    session = user.sessions.create!
    cookies[:session_token] = session.id.to_s
  end
  
  
  
  describe "GET /sessions" do
    context "when authenticated" do
      before do
        sign_in user
      end

      it "lists sessions" do
        get sign_in_path
        expect(response).to have_http_status(:ok)
      end
    end

    
  end

  describe "GET /sessions/new" do
    it "renders the new session page" do
      get sign_in_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /sessions" do
    context "with valid credentials" do
      it "creates a new session and redirects" do
        post sign_in_path, params: { email: user.email, password: 'password123' }
        expect(response).to redirect_to(portfolios_path)
      end
    end

    context "with invalid credentials" do
      it "does not create a session and redirects to sign in" do
        post sign_in_path, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to redirect_to(sign_in_path(email_hint: user.email))
      end
    end

    context "with non-existent email" do
      it "does not create a session and redirects to sign in" do
        post sign_in_path, params: { email: 'nonexistent@example.com', password: 'password123' }
        expect(response).to redirect_to(sign_in_path(email_hint: 'nonexistent@example.com'))
      end
      
   end

   context "with a user awaiting approval" do
      let(:unapproved_user) { create(:user, status: "Pending", password: 'password123', password_confirmation: 'password123') }

      it "does not create a session and redirects to sign in" do
        post sign_in_path, params: { email: 'nonexistent@example.com', password: 'password123' }
        expect(response).to redirect_to(sign_in_path(email_hint: 'nonexistent@example.com'))
      end
      
   end
  end

  describe "DELETE /sessions/:id" do
    let(:session) { user.sessions.create! }

    context "when authenticated" do
      before do
        sign_in user
      end

      it "destroys the session and redirects" do
        delete session_path(session.id)
        expect(response).to redirect_to(sign_in_path)
      end  
   end


    context "when not authenticated" do
      it "redirects to sign in" do
        delete session_path(session.id)
        expect(response).to redirect_to(sign_in_path)

      end
    end
  end
end
