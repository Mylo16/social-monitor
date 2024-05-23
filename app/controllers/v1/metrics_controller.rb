class V1::MetricsController < ApplicationController
  before_action :require_login

  def index
    @post = Post.find(params[:post_id])
    @metrics = @post.metrics.all
    render json: @metrics
  end

  def show
    @post = Post.find(params[:post_id])
    @metric = @post.metrics.find(params[:id])
    render json: @metric
  end

  def create
    @metric = Metric.new(post_params)
    @metric.post_id = params[:post_id]
    if @metric.save
      render json: @metric, status: :created
    else
      render json: @metric.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @metric = @post.metrics.find(params[:id])
    @metric.destroy
    render json: { message: 'Metric deleted successfully' }
  end

  private

  def metric_params
    params.require(:metric).permit(:likes, :comments_count, :shares, :post_id, :impressions)
  end
end
