require 'rails_helper'

RSpec.describe EmailVerificationToken, type: :model do

  it "has a valid factory" do
    user = create(:user)
    email_verification_token = build(:email_verification_token, user: user)
    expect(email_verification_token).to be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    subject { build(:email_verification_token) }

    it { should validate_presence_of(:user_id) }
  end
end
