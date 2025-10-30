class NotificationService
  NOTIFICATION_SERVICES = {
    'email' => Channels::EmailService,
    'sms' => Channels::SmsService
  }.freeze

  def self.deliver(notification)
    service = NOTIFICATION_SERVICES[notification.channel]

    raise ArgumentError, "Unknown channel: #{notification.channel}." unless service

    service.new(notification).call
  end
end
