require 'rails_helper'

RSpec.describe Channels::DiscordService do
  subject(:service) { described_class.new(notification) }

  let(:notification) do
    create(
      :notification,
      channel: 'discord',
      recipient: 'https://discord.com/api/webhooks/123/abcDEF',
      subject: 'Test',
      body: 'Discord message'
    )
  end

  before do
    allow(notification).to receive(:update!)
  end

  context 'when message delivery succeeds' do
    it 'marks as sent' do
      allow(service).to receive(:make_request).and_return(Net::HTTPSuccess.new('1.1', '200', 'OK'))

      service.call

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :sent))
    end
  end

  context 'when request raises network errors' do
    before do
      allow(service).to receive(:make_request).and_raise(SocketError, 'network error')
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(SocketError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[DiscordService\] Network error while sending Discord notification: network error/)
    end
  end

  context 'when API returns error response (non-success HTTP)' do
    before do
      allow(service).to receive(:make_request).and_return(instance_double(Net::HTTPBadRequest, body: 'standard error'))
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(StandardError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[DiscordService\] Failed to send Discord notification: Discord API error: standard error/)
    end
  end
end
