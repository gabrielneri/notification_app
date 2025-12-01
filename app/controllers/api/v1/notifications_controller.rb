class Api::V1::NotificationsController < Api::V1::BaseController
  def create
    notification = Notification.new(notification_params)

    if notification.save
      NotificationWorker.perform_async(notification.id.to_s)
      render json: { data: notification }, status: :created
    else
      render json: { errors: notification.errors }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:body, :channel, :recipient, :subject)
  end
end
