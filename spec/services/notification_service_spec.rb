require 'rails_helper'

RSpec.describe NotificationService do
  describe '.deliver' do
    subject(:deliver) { described_class.deliver(notification) }

    let(:notification) do
      instance_double(Notification, channel: channel)
    end

    context 'when channel is email' do
      let(:channel) { 'email' }

      it 'calls the Email service' do
        email_service = instance_double(Channels::EmailService, call: true)

        allow(Channels::EmailService).to receive(:new).with(notification).and_return(email_service)

        deliver

        expect(Channels::EmailService).to have_received(:new).with(notification)
        expect(email_service).to have_received(:call)
      end
    end

    context 'when channel is sms' do
      let(:channel) { 'sms' }

      it 'calls the Sms service' do
        sms_service = instance_double(Channels::SmsService, call: true)

        allow(Channels::SmsService).to receive(:new).with(notification).and_return(sms_service)

        deliver

        expect(Channels::SmsService).to have_received(:new).with(notification)
        expect(sms_service).to have_received(:call)
      end
    end

    context 'when channel is telegram' do
      let(:channel) { 'telegram' }

      it 'calls the Telegram service' do
        telegram_service = instance_double(Channels::TelegramService, call: true)

        allow(Channels::TelegramService).to receive(:new).with(notification).and_return(telegram_service)

        deliver

        expect(Channels::TelegramService).to have_received(:new).with(notification)
        expect(telegram_service).to have_received(:call)
      end
    end

    context 'when channel is discord' do
      let(:channel) { 'discord' }

      it 'calls the Discord service' do
        discord_service = instance_double(Channels::DiscordService, call: true)

        allow(Channels::DiscordService).to receive(:new).with(notification).and_return(discord_service)

        deliver

        expect(Channels::DiscordService).to have_received(:new).with(notification)
        expect(discord_service).to have_received(:call)
      end
    end

    context 'when channel is unknown' do
      let(:channel) { 'unknown_channel' }

      it 'raises an ArgumentError' do
        expect { deliver }.to raise_error(ArgumentError, 'Unknown channel: unknown_channel.')
      end
    end
  end
end
