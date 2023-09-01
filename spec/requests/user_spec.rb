require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user, role: 'Trader') }
  let!(:admin) { create(:user, role: 'Admin') }
  let!(:pending_user) { create(:user, status: 'Pending') }

  let(:valid_attributes) { { email: 'test@example.com', password: 'password', role: 'Trader', status: 'Approved' } }
  let(:invalid_attributes) { { email: '', password: '', role: '', status: '' } }

  # Mock authentication before each test
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe "GET /index" do
    context "as admin" do
      before { allow(Current).to receive(:user).and_return(admin) }

      it "renders the index template" do
        get users_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "as non-admin" do
      before { allow(Current).to receive(:user).and_return(user) }

      it "redirects to root with an alert" do
        get users_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Not authorized!')
      end
    end
  end

  describe "GET /show/:id" do
    context "as an admin" do
      before { allow(Current).to receive(:user).and_return(admin) }
  
      it "renders the show template" do
        get user_path(user)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
    end
  end
  
  describe "GET /edit/:id" do
    context "as an admin" do
      before { allow(Current).to receive(:user).and_return(admin) }
  
      it "renders the edit template" do
        get edit_user_path(user)
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET /new" do
    context "as admin" do
      before { allow(Current).to receive(:user).and_return(admin) }

      it "renders the new template" do
        get new_user_path
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
    end

    context "as non-admin" do
      before { allow(Current).to receive(:user).and_return(user) }

      it "redirects to root with an alert" do
        get new_user_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Not authorized!')
      end
    end
  end

  describe "PATCH /approve/:id" do
    context "when user is approved successfully" do
      before do
        allow(Current).to receive(:user).and_return(admin)
        allow(UserMailer.with(user: pending_user).approval_notification).to receive(:deliver_now)
      end

      it "approves the user and sends a notification" do
        patch approve_user_path(pending_user)

        expect(pending_user.reload.status).to eq('Approved')
        expect(flash[:notice]).to eq("Trader approved and notified successfully!")
      end
    end

    context "when there's an error approving the user" do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch approve_user_path(pending_user)
      end
    
      it "shows an error" do
        expect(flash[:alert]).to eq("There was an error approving the trader.")
      end
    end
    
  end

  describe "POST /users" do
    context "as an admin" do
      let!(:admin) { create(:user, :admin) }
  
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
        allow(Current).to receive(:user).and_return(admin)
      end
  
      it "fails to create a new user with invalid attributes" do
        post users_path, params: { user: { email: '' } } 
        expect(response).to render_template(:new)
      end
    end
  end
  
  describe "PATCH /users/:id" do
    context "as an admin" do
      before { allow(Current).to receive(:user).and_return(admin) }
  
      it "updates user successfully" do
        patch user_path(user), params: { user: { email: 'newemail@test.com' } }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:notice]).to eq('User was successfully updated.')
        puts user.reload.errors.full_messages # 
        expect(user.reload.email).to eq('newemail@test.com')
      end
      
  
      it "fails to update user with invalid attributes" do
        patch user_path(user), params: { user: { email: '' } } 
        expect(response).to render_template(:edit)
      end
    end
  end
  
  describe "DELETE /users/:id" do
    let!(:user) { create(:user) }
  
    context "as an admin" do
      let!(:admin) { create(:user, :admin) }
  
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
        allow(Current).to receive(:user).and_return(admin)
      end
  
      it "deletes user successfully" do
        delete user_path(user)
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('User was successfully deleted.')
        expect(User.find_by(id: user.id)).to be_nil
      end
    end
  end
end
