require 'rails_helper'

RSpec.describe Identity::EmailVerificationsController, type: :request do
  let(:user) { create(:user, verified: false) }
  let(:valid_token_string) { "someEncryptedOrSignedString" }
  let(:valid_token) { instance_double("EmailVerificationToken", user: user) }

  before do
    # Mock Current.user
    allow(Current).to receive(:user).and_return(user)
    # Mock authentication check
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe '#show' do
    context 'with valid email verification token' do
      before do
        allow(EmailVerificationToken).to receive(:find_signed!).with(valid_token_string).and_return(valid_token)
        get identity_email_verification_path(sid: valid_token_string)
      end

      it 'verifies the user' do
        user.reload
        expect(user.verified).to be true
      end

      it 'redirects to the root path with a notice' do
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Thank you for verifying your email address")
      end
    end

    context 'with invalid email verification token' do
      before do
        allow(EmailVerificationToken).to receive(:find_signed!).and_raise(StandardError)
        get identity_email_verification_path(sid: "invalidToken")
      end

      it 'does not verify the user' do
        user.reload
        expect(user.verified).to be false
      end

      it 'redirects to edit_identity_email_path with an alert' do
        expect(response).to redirect_to(edit_identity_email_path)
        expect(flash[:alert]).to eq("That email verification link is invalid")
      end
    end
  end

  describe '#create' do
    before do
      allow(UserMailer).to receive_message_chain(:with, :email_verification, :deliver_later)
      post identity_email_verification_path
    end

    it 'sends an email verification' do
      expect(UserMailer).to have_received(:with).with(user: user)
    end

    it 'redirects to the root path with a notice' do
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("We sent a verification email to your email address")
    end
  end
end
