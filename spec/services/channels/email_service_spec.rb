require 'rails_helper'

RSpec.describe Channels::EmailService do
  subject(:service) { described_class.new(notification) }

  let(:notification) do
    create(
      :notification,
      channel: 'email',
      recipient: 'email@example.com',
      subject: 'Subject',
      body: 'Email message'
    )
  end

  before do
    allow(notification).to receive(:update!)
  end

  context 'when email delivery succeeds' do
    before do
      mailer_double = instance_double(ActionMailer::MessageDelivery)
      allow(NotificationMailer).to receive(:notification_email).and_return(mailer_double)
      allow(mailer_double).to receive(:deliver_now)
    end
    it 'marks as sent' do
      service.call

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :sent))
    end
  end

  context 'when mailer raises an error' do
    before do
      allow(NotificationMailer).to receive(:notification_email).and_raise(StandardError, 'SMTP error')
      allow(Rails.logger).to receive(:error)
    end

    it 'marks as failed and re-raises' do
      expect { service.call }.to raise_error(StandardError)

      expect(notification).to have_received(:update!).with(hash_including(status: :processing))
      expect(notification).to have_received(:update!).with(hash_including(status: :failed))

      expect(Rails.logger).to have_received(:error)
        .with(/\[EmailService\] Email delivery failed: SMTP error/)
    end
  end
end
