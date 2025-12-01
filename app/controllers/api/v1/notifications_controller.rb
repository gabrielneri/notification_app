class Api::V1::NotificationsController < Api::V1::BaseController
  def show
    notification = Notification.find(params[:id])

    render json: { data: notification.as_json(only: %i[id subject body recipient channel status]) }
  end

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
