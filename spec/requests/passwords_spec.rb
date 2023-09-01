require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(true)
  end

  describe '#edit' do
    context 'when user is authenticated' do
      before do
        user = create(:user) 
        allow(Current).to receive(:user).and_return(user) 
        get edit_password_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#update' do
    let(:user) { create(:user, password: 'oldpassword123', password_confirmation: 'oldpassword123') }

    before do
      allow(Current).to receive(:user).and_return(user)
    end

    context 'when current password is incorrect' do
      it 'redirects with an alert message' do
        patch password_path, params: { current_password: 'wrongpassword' }
        expect(response).to redirect_to(edit_password_path)
        expect(flash[:alert]).to eq("The current password you entered is incorrect")
      end
    end

    context 'when new password and confirmation match' do
      let(:new_password_params) do
        {
          current_password: 'oldpassword123',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'updates the user password and redirects to root' do
        patch password_path, params: new_password_params
        expect(user.reload.authenticate('newpassword123')).to be_truthy
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Your password has been changed")
      end
    end

    context 'when new password and confirmation do not match' do
      let(:mismatched_password_params) do
        {
          current_password: 'oldpassword123',
          password: 'newpassword123',
          password_confirmation: 'differentpassword123'
        }
      end

      it 'renders the edit view with an error status' do
        patch password_path, params: mismatched_password_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end
end
