class Api::V1::ProgressesController < ApplicationController
  before_action :require_login
  # GET /progresses
  def index
    @quiz = Quiz.find(params[:quiz_id])
    @progress = @quiz.progresses
    render json: @progress
  end

  # GET /progresses/:id
  def show
    # @progress = Progress.find(params[:id])
    # render json: @progress
    @quiz = Quiz.find(params[:quiz_id])
    @user = session_user
    @progress = Progress.find_by(quiz: @quiz, user: @user)
    render json: @progress
  end

  def create
    @progress = Progress.new(progress_params)
    if @progress.save
      render json: @progress, status: :created
    else
      render json: @progress.errors, status: :unprocessable_entity
    end
  end

  def new
    @progress = Progress.new
  end

  def update
    @progress = Progress.find(params[:id])
    if @progress.update(progress_params)
      render json: @progress
    else
      render json: @progress.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @progress = Progress.find(params[:id])
      @progress.destroy
      render json: { message: 'Progress deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this Progress' }
    end
  end

  private

  def progress_params
    params.require(:progress).permit(:user_id, :course_id, :quiz_id, :total_marks_available, :total_marks_obtained, :grade, :course_code, :exam_title)
  end
end
