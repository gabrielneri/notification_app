module Channels
  class ApplicationService
    def initialize(notification)
      @notification = notification
    end

    private

    attr_reader :notification

    def mark_as_processing
      notification.update!(status: :processing)
    end

    def mark_as_sent
      notification.update!(status: :sent, sent_at: Time.current, failed_at: nil)
    end

    def mark_as_failed
      notification.update!(status: :failed, failed_at: Time.current)
    end

    def make_request(uri, payload)
      req = Net::HTTP::Post.new(uri, { 'Content-Type' => 'application/json' })
      req.body = payload.to_json

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end
    end
  end
end
