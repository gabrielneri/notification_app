require 'rails_helper'

RSpec.describe Channels::SmsService do
  subject(:service) { described_class.new(notification) }

  let(:notification) { create(:notification, channel: 'sms', recipient: '+5577999999999') }

  before { allow(service).to receive(:sleep) }

  context 'when delivery succeeds' do
    before do
      allow(service).to receive(:rand).and_return(10)
      allow(notification).to receive(:update!)
    end

    it 'marks as sent' do
      service.call

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :sent))
    end
  end

  context 'when delivery fails' do
    before do
      allow(service).to receive(:rand).and_return(1)
      allow(notification).to receive(:update!)
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(StandardError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[SmsService\] Simulated API failure for notification ##{notification.id}\./)
    end
  end
end
