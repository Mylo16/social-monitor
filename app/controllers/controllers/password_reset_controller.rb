class PasswordResetController < ApplicationController
  skip_before_action :require_login, only: [:create, :update]

  def create
    user = User.find_by(email: params[:email])
    if user
      expiration_time = 1.hour.from_now.to_i
      token = JWT.encode({ user_id: user.id, exp: expiration_time }, 'my_secret')
      PasswordResetMailer.reset_password_email(user.email, token).deliver_now
      render json: token
    else
      render json: { error: 'User not found with the provided email.' }, status: :not_found
    end
  end


  def update
    begin
      decoded_token = JWT.decode(params[:token], 'my_secret', true, algorithm: 'HS256')
      user_id = decoded_token.first['user_id']
      user = User.find(user_id)

      if user
        if decoded_token.first['exp'] && Time.now.to_i > decoded_token.first['exp']
          render json: { error: 'Token has expired.' }, status: :unprocessable_entity
        else
          new_password = params[:password]
          user.update(password: new_password)
          render json: { message: 'Password successfully updated' }
        end
      else
        render json: { error: 'User not found.' }, status: :not_found
      end
    rescue JWT::DecodeError
      render json: { error: 'Invalid or expired token.' }, status: :unprocessable_entity
    end
  end

  private

  def expiration_time
    1.hour.from_now.to_i
  end
end
