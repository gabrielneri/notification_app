require 'rails_helper'

RSpec.describe 'Api::V1::Notifications', type: :request do
  describe 'POST /api/v1/notifications' do
    let(:valid_params) do
      { notification: { channel: 'email', recipient: 'email@example.com', subject: 'Test', body: 'Test message' } }
    end

    let(:invalid_params) do
      { notification: { channel: 'email', recipient: nil, subject: nil, body: nil } }
    end

    before do
      allow(NotificationWorker).to receive(:perform_async)
    end

    context 'with valid params' do
      it 'create a notification and enqueues the worker' do
        post '/api/v1/notifications', params: valid_params, as: :json

        expect(response).to have_http_status(:created)

        json = response.parsed_body

        expect(json['data']).to include(
          'recipient' => 'email@example.com',
          'status' => 'pending'
        )

        notification = Notification.last
        expect(NotificationWorker).to have_received(:perform_async).with(notification.id.to_s)
      end
    end

    context 'with invalid params' do
      it 'does not create a notification and returns unprocessable entity' do
        post '/api/v1/notifications', params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)

        json = response.parsed_body
        expect(json).to have_key('errors')
      end
    end
  end

  describe 'GET /api/v1/notifications/:id' do
    subject(:request) { get api_v1_notification_path(notification_id) }

    let!(:notification) { create(:notification) }
    let(:notification_id) { notification.id }

    context 'when notification exists' do
      it 'returns the notification' do
        request

        expect(response).to have_http_status(:ok)

        json = response.parsed_body

        expect(json['data']).to include(
          'id' => notification.id,
          'subject' => notification.subject,
          'body' => notification.body,
          'recipient' => notification.recipient,
          'channel' => notification.channel,
          'status' => notification.status
        )
      end
    end

    context 'when notification does not exist' do
      let(:notification_id) { -1 }

      it 'returns not found error' do
        request

        json = response.parsed_body

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Resource not found')
      end
    end
  end
end
