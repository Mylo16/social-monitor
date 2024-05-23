class V1::SocialAccountsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @social_accounts = @user.social_accounts.all
    render json: @social_accounts
  end

  def show
    @user = User.find(params[:user_id])
    @social_account = @user.social_accounts.find(params[:id])
    render json: @social_account
  end

  def new
    @social_account = SocialAccount.new
  end

  def create
    @social_account = SocialAccount.new(social_account_params)
    @social_account.user_id = params[:user_id]
    if @social_account.save
      render json: @social_account, status: :created
    else
      render json: @social_account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @social_account = session_user.social_accounts.find(params[:id])
    @social_account.destroy
    render json: { message: 'Social Account deleted successfully' }
  end

  private

  def social_account_params
    params.require(:social_account).permit(:user_id, :platform, :username, :access_token)
  end
end
