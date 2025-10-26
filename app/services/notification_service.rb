class NotificationService
  NOTIFICATION_SERVICES = {
    'email' => EmailService
  }.freeze

  def self.deliver(notification)
    service = NOTIFICATION_SERVICES[notification.channel]

    raise ArgumentError, "Unknown channel: #{notification.channel}." unless service

    service.deliver(notification)
  end
end
