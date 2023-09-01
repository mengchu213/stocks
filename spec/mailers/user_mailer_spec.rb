require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  describe 'password_reset' do
    let(:mail) { UserMailer.with(user: user).password_reset }

    it 'renders the headers' do
      expect(mail.subject).to eq('Reset your password')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['jose.infante@cghc.edu.ph'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.email)
    end
  end

  describe 'email_verification' do
    let(:mail) { UserMailer.with(user: user).email_verification }

    it 'renders the headers' do
      expect(mail.subject).to eq('Registration pending approval, Verify your email')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['jose.infante@cghc.edu.ph'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.email)
    end
  end

  describe 'approval_notification' do
    let(:mail) { UserMailer.with(user: user).approval_notification }

    it 'renders the headers' do
      expect(mail.subject).to eq('You have been approved!')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['jose.infante@cghc.edu.ph'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.email)
    end
  end
end
