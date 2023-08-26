# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do

  # Setting up the factory
  let(:user) { build(:user) }

  # Testing validations
  context 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid email format' do
      user.email = 'invalidemail'
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicated email' do
      create(:user, email: 'duplicate@example.com')
      user.email = 'duplicate@example.com'
      expect(user).to_not be_valid
    end

    it 'is not valid without a password digest' do
      user.password_digest = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a role' do
      user.role = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid role' do
      user.role = 'InvalidRole'
      expect(user).to_not be_valid
    end

    it 'is not valid without a status' do
      user.status = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid status' do
      user.status = 'InvalidStatus'
      expect(user).to_not be_valid
    end

    it 'is not valid without a balance' do
      user.balance = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with a negative balance' do
      user.balance = -1
      expect(user).to_not be_valid
    end

    # Add more validation checks similarly...
  end

  # Testing associations
  context 'associations' do
    it 'should have many transactions' do
      association = described_class.reflect_on_association(:transactions)
      expect(association.macro).to eq :has_many
    end

    it 'should have many portfolios' do
      association = described_class.reflect_on_association(:portfolios)
      expect(association.macro).to eq :has_many
    end

    # ... more association tests as needed
  end

  # Testing callbacks
  context 'callbacks' do
    it 'downcases the email before validation' do
      user.email = 'Test@Example.com'
      user.valid? # Triggers the before_validation callback
      expect(user.email).to eq('test@example.com')
    end

    it 'sets verified to false if the email changed on update' do
      existing_user = create(:user, email: 'original@example.com')
      existing_user.email = 'new@example.com'
      existing_user.save
      expect(existing_user.verified).to be false
    end

    it 'deletes other sessions if password digest changes' do
      # Here you'd set up a scenario where a user has multiple sessions.
      # Then change the password and see if other sessions than the current are destroyed.
    end
  end
end
