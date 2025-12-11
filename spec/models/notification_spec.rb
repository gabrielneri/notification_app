require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it 'is valid with default factory' do
      expect(build(:notification)).to be_valid
    end

    it 'is invalid when recipient is blank for any channel' do
      notification = build(:notification, recipient: nil)
      expect(notification).not_to be_valid
    end

    context 'when channel is email' do
      let(:notification) do
        build(:notification, channel: :email, subject: 'Subject', body: 'Email message')
      end

      it 'is valid with a valid email' do
        notification.recipient = 'email@example.com'
        expect(notification).to be_valid
      end

      it 'is invalid with an invalid email' do
        notification.recipient = 'email.com'
        expect(notification).not_to be_valid
      end

      it 'is invalid without subject' do
        notification.subject = nil
        expect(notification).not_to be_valid
      end
    end

    context 'when channel is sms' do
      let(:notification) do
        build(:notification, channel: :sms, subject: nil, body: 'SMS message')
      end

      it 'is valid with a valid phone number' do
        notification.recipient = '+5577999999999'
        expect(notification).to be_valid
      end

      it 'is invalid with an invalid phone number' do
        notification.recipient = 'invalid-phone-number-123'
        expect(notification).not_to be_valid
      end
    end

    context 'when channel is telegram' do
      let(:notification) do
        build(:notification, channel: :telegram, subject: nil, body: 'Telegram message')
      end

      it 'is valid with any non-empty recipient' do
        notification.recipient = '123456789'
        expect(notification).to be_valid
      end

      it 'is invalid when recipient is blank' do
        notification.recipient = nil
        expect(notification).not_to be_valid
      end
    end

    context 'when channel is discord' do
      let(:notification) do
        build(:notification, channel: :discord, subject: nil, body: 'Discord message')
      end

      it 'is valid with a proper webhook URL' do
        notification.recipient = 'https://discord.com/api/webhooks/123/abcDEF'
        expect(notification).to be_valid
      end

      it 'is invalid with a malformed webhook URL' do
        notification.recipient = 'https://discord.com/api/invalid'
        expect(notification).not_to be_valid
      end
    end
  end

  describe 'enums' do
    it { should define_enum_for(:channel).with_values(email: 0, sms: 1, telegram: 2, discord: 3) }
    it { should define_enum_for(:status).with_values(pending: 0, processing: 1, sent: 2, failed: 3) }
  end
end
