# spec/models/password_reset_token_spec.rb
require 'rails_helper'

RSpec.describe PasswordResetToken, type: :model do
  # Factory
  it "has a valid factory" do
    user = create(:user)
    password_reset_token = build(:password_reset_token, user: user)
    expect(password_reset_token).to be_valid
  end

  # Associations
  describe "associations" do
    it { should belong_to(:user) }
  end

  # Validations
  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end
end
