class V1::NotificationsController < ApplicationController
  before_action :require_login

  def index
    @user = User.find(params[:user_id])
    @notifications = @user.notifications.all
    render json: @notifications
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.user_id = params[:user_id]
    if @notification.save
      render json: @notification, status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:content, :read, :user_id)
  end
end
