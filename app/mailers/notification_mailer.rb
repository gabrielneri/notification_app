class NotificationMailer < ApplicationMailer
  def notification_email(notification)
    @notification = notification

    mail(to: @notification.recipient, subject: @notification.subject)
  end
end
