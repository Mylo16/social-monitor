class V1::UsersController < ApplicationController
  before_action :require_login
  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def new
    @user = User.new
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      payload = { user_id: @user.id }
      token = encode_token(payload)
      puts token
      render json: { user: @user, jwt: token }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @user = User.find(params[:id])
      @user.destroy
      render json: { message: 'User deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this user' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :user_type, :password)
  end
end
