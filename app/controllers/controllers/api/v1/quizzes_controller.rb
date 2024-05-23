class Api::V1::QuizzesController < ApplicationController
  before_action :require_login
  before_action :set_course
  # GET /users
  def index
    @quizzes = @course.quizzes.all
    render json: @quizzes
  end

  # GET /cars/:id
  def show
    @quiz = @course.quizzes.find(params[:id])
    render json: @quiz
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      render json: @quiz, status: :created
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  def new
    @quiz = Quiz.new
  end

  def update
    @quiz = @course.quizzes.find(params[:id])
    if @quiz.update(quiz_params)
      render json: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @quiz = @course.quizzes.find(params[:id])
      @quiz.destroy
      render json: { message: 'Quiz deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this quiz' }
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def quiz_params
    params.require(:quiz).permit(:exam_date, :exam_title, :duration, :total_marks, :course_id)
  end
end
