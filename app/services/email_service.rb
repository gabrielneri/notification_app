class EmailService
  def self.deliver(notification)
    notification.update!(status: 'processing')

    begin
      NotificationMailer.notification_email(notification).deliver_now
      notification.update!(status: 'sent')
    rescue Net::SMTPFatalError, StandardError => e
      notification.update!(status: 'failed')
      Rails.logger.error "[EmailService] Email failed: #{e.message}"
      raise
    end
  end
end
