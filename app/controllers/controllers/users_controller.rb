class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    @user = User.create(user_params)
    if @user.valid?
      payload = { user_id: @user.id }
      token = encode_token(payload)
      puts token
      render json: { user: @user, jwt: token }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :full_name, :user_type, :password)
  end
end
