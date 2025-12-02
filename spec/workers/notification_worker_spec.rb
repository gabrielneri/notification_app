require 'rails_helper'

RSpec.describe NotificationWorker, type: :job do
  subject(:worker) { described_class.new }

  describe '#perform' do
    let!(:notification) { create(:notification) }
    let(:notification_id) { notification.id }

    context 'when notification exists' do
      it 'calls NotificationService.deliver' do
        allow(NotificationService).to receive(:deliver)

        worker.perform(nil, notification_id)

        expect(NotificationService).to have_received(:deliver).with(notification)
      end
    end

    context 'when notification does not exist' do
      let(:notification_id) { -1 }

      it 'logs an error and does not raise' do
        allow(Rails.logger).to receive(:error)

        expect { worker.perform(nil, notification_id) }.not_to raise_error

        expect(Rails.logger).to have_received(:error).with(/\[NotificationWorker\] Notification not found/)
      end
    end

    context 'when NotificationService raises an error' do
      it 'logs the error and re-raises' do
        allow(NotificationService).to receive(:deliver).and_raise(StandardError.new('error'))
        allow(Rails.logger).to receive(:error)

        expect { worker.perform(nil, notification_id) }.to raise_error(StandardError, 'error')

        expect(Rails.logger).to have_received(:error).with(/\[NotificationWorker\] Failed to process notification/)
      end
    end
  end
end
