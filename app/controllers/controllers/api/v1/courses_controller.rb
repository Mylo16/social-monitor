class Api::V1::CoursesController < ApplicationController
  before_action :require_login
  # GET /users
  def index
    @courses = Course.includes(:quizzes).includes(:enrollments).includes(:users).includes(:materials).includes(:progresses).all
    render json: @courses
  end

  # GET /cars/:id
  def show
    @course = Course.find(params[:id])
    render json: @course
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      render json: @course, status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def new
    @course = Course.new
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      render json: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @course = Course.find(params[:id])
      @course.destroy
      render json: { message: 'Course deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this course' }
    end
  end

  private

  def course_params
    params.require(:course).permit(:course_code, :course_name, :semester, :year)
  end
end
