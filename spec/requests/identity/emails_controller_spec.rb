require 'rails_helper'

RSpec.describe Identity::EmailsController, type: :request do
  let(:user) { create(:user, password: 'password123', password_confirmation: 'password123', email: 'old@example.com') }

  before do
    # Mock Current.user
    allow(Current).to receive(:user).and_return(user) 
    # Mock authentication check
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe '#edit' do
    context 'when user is authenticated' do
      before do
        get edit_identity_email_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    context 'when the password is incorrect' do
      before do
        patch identity_email_path, params: { current_password: 'wrongpassword', email: 'new@example.com' }
      end

      it 'redirects with an alert message' do
        expect(response).to redirect_to(edit_identity_email_path)
        expect(flash[:alert]).to eq("The password you entered is incorrect")
      end
    end

    context 'when the email is successfully updated' do
      before do
        allow(UserMailer).to receive_message_chain(:with, :email_verification, :deliver_later)
        patch identity_email_path, params: { current_password: 'password123', email: 'new@example.com' }
      end

      it 'redirects to the root path with a notice' do
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Your email has been changed")
      end
      
      it 'sends an email verification' do
        expect(UserMailer).to have_received(:with).with(user: user)
      end
    end
    
    context 'when the email remains the same' do
      before do
        allow(UserMailer).to receive_message_chain(:with, :email_verification, :deliver_later)
        patch identity_email_path, params: { current_password: 'password123', email: 'old@example.com' }
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'does not send an email verification' do
        expect(UserMailer).not_to have_received(:with)
      end
    end

    context 'when the email update fails' do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch identity_email_path, params: { current_password: 'password123', email: 'invalid_email' }
      end

      it 'renders the edit view with an error status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
