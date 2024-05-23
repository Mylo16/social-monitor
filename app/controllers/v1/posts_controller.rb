class V1::PostsController < ApplicationController
  before_action :require_login

  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.all
    render json: @posts
  end

  def show
    @user = User.find(params[:user_id])
    @post = @user.posts.find(params[:id])
    render json: @post
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = params[:user_id]
    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @post = @user.posts.find(params[:id])
    @post.destroy
    render json: { message: 'Post deleted successfully' }
  end

  private

  def post_params
    params.require(:post).permit(:content, :status, :social_account_id, :user_id)
  end
end
