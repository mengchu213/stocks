# spec/models/email_verification_token_spec.rb
require 'rails_helper'

RSpec.describe EmailVerificationToken, type: :model do
  # Factory
  it "has a valid factory" do
    user = create(:user)
    email_verification_token = build(:email_verification_token, user: user)
    expect(email_verification_token).to be_valid
  end
  

  # Associations
  describe "associations" do
    it { should belong_to(:user) }
  end

  # Validations
  describe "validations" do
    subject { build(:email_verification_token) }

    it { should validate_presence_of(:user_id) }
  end
end
