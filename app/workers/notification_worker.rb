class NotificationWorker
  include Shoryuken::Worker

  shoryuken_options queue: ENV.fetch('SQS_QUEUE_NAME'), auto_delete: true

  def perform(_sqs_msg, notification_id)
    notification = Notification.find(notification_id)
    NotificationService.deliver(notification)
  rescue ActiveRecord::RecordNotFound => _e
    Rails.logger.error "[NotificationWorker] Notification not found - (id : #{notification_id})."
  rescue StandardError => e
    Rails.logger.error "[NotificationWorker] Failed to process notification ##{notification_id}: #{e.message}"
    raise
  end
end
