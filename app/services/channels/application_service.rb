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
  end
end
