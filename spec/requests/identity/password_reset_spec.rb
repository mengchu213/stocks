require 'rails_helper'

RSpec.describe Identity::PasswordResetsController, type: :request do
  let(:user) { create(:user, verified: true) }
  let(:valid_token_string) { "someEncryptedOrSignedString" }
  let(:valid_token) { instance_double("PasswordResetToken", user: user) }

  before do
    # Mock authentication check
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe '#new' do
    it 'renders the new template' do
      get new_identity_password_reset_path
      expect(response).to render_template(:new)
    end
  end

  describe '#edit' do
    context 'with valid password reset token' do
      before do
        allow(PasswordResetToken).to receive(:find_signed!).with(valid_token_string).and_return(valid_token)
        get edit_identity_password_reset_path(sid: valid_token_string)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'with invalid password reset token' do
      before do
        allow(PasswordResetToken).to receive(:find_signed!).and_raise(StandardError)
        get edit_identity_password_reset_path(sid: "invalidToken")
      end

      it 'redirects to new_identity_password_reset_path with an alert' do
        expect(response).to redirect_to(new_identity_password_reset_path)
        expect(flash[:alert]).to eq("That password reset link is invalid")
      end
    end
  end

  describe '#create' do
    context 'with verified user email' do
      before do
        allow(UserMailer).to receive_message_chain(:with, :password_reset, :deliver_later)
        post identity_password_reset_path, params: { email: user.email }
      end

      it 'sends a password reset email' do
        expect(UserMailer).to have_received(:with).with(user: user)
      end

      it 'redirects to sign_in_path with a notice' do
        expect(response).to redirect_to(sign_in_path)
        expect(flash[:notice]).to eq("Check your email for reset instructions")
      end
    end

    context 'with unverified user email or nonexistent email' do
      let(:unverified_user) { create(:user, verified: false) }

      before do
        post identity_password_reset_path, params: { email: unverified_user.email }
      end

      it 'redirects to new_identity_password_reset_path with an alert' do
        expect(response).to redirect_to(new_identity_password_reset_path)
        expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
      end
    end
  end

  describe '#update' do
    context 'with valid password data' do
      before do
        allow(PasswordResetToken).to receive(:find_signed!).with(valid_token_string).and_return(valid_token)
        put identity_password_reset_path(sid: valid_token_string), params: { password: "newpassword", password_confirmation: "newpassword" }
      end

      it 'updates the user password' do
        user.reload
        expect(user.authenticate("newpassword")).to be_truthy
      end

      it 'redirects to sign_in_path with a notice' do
        expect(response).to redirect_to(sign_in_path)
        expect(flash[:notice]).to eq("Your password was reset successfully. Please sign in")
      end
    end

    context 'with invalid password data' do
      before do
        allow(PasswordResetToken).to receive(:find_signed!).with(valid_token_string).and_return(valid_token)
        put identity_password_reset_path(sid: valid_token_string), params: { password: "newpassword", password_confirmation: "differentpassword" }
      end

      it 'does not update the user password' do
        user.reload
        expect(user.authenticate("newpassword")).to be_falsey
      end

      it 'renders the edit template with status unprocessable_entity' do
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
