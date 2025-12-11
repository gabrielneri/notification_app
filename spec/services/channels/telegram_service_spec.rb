require 'rails_helper'

RSpec.describe Channels::TelegramService do
  subject(:service) { described_class.new(notification) }

  let(:notification) do
    create(
      :notification,
      channel: 'telegram',
      recipient: '123456789',
      subject: 'Test telegram',
      body: 'Telegram message'
    )
  end

  before do
    allow(notification).to receive(:update!)
  end

  context 'when the delivery succeeds' do
    it 'marks as sent' do
      allow(service).to receive(:make_request).and_return(Net::HTTPSuccess.new('1.1', '200', 'OK'))

      service.call

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :sent))
    end
  end

  context 'when a network error is raised' do
    before do
      allow(service).to receive(:make_request).and_raise(SocketError, 'network error')
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(SocketError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[TelegramService\] Network error while sending Telegram notification: network error/)
    end
  end

  context 'when API response is not success' do
    before do
      bad_response = instance_double(Net::HTTPBadRequest, body: 'telegram error')
      allow(service).to receive(:make_request).and_return(bad_response)
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(StandardError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[TelegramService\] Failed to send Telegram notification: Telegram API error: telegram error/)
    end
  end
end
