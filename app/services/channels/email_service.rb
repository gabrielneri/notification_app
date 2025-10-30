module Channels
  class EmailService < ApplicationService
    def call
      mark_as_processing
      NotificationMailer.notification_email(notification).deliver_now
      mark_as_sent
    rescue Net::SMTPFatalError, StandardError => e
      mark_as_failed
      Rails.logger.error "[EmailService] Email delivery failed: #{e.message}"
      raise
    end
  end
end
