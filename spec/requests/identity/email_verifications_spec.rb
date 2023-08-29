require 'rails_helper'

RSpec.describe 'Identity::EmailVerifications', type: :request do
  describe 'GET #show' do
    context 'with a valid signed token' do
      let(:user) { FactoryBot.create(:user, verified: false) }
      let(:token) { EmailVerificationToken.create_with_signature(user: user) }

      
      
    end

    context 'with an invalid signed token' do
      it 'redirects to edit_identity_email_path with an alert' do
        get identity_email_verification_path(sid: 'invalid_token')

        expect(response).to redirect_to(edit_identity_email_path)
        expect(flash[:alert]).to eq('That email verification link is invalid')
      end
    end
  end

  describe 'POST #create' do
    before do
      # Mock current user and other necessary setups
    end

    
  end
end
