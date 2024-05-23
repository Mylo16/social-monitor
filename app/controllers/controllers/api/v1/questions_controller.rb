class Api::V1::QuestionsController < ApplicationController
  before_action :require_login
  # GET /questions
  def index
    @quiz = Quiz.find(params[:quiz_id])
    @questions = @quiz.questions.order("RANDOM()")
    render json: @questions
  end

  # GET /questions/:id
  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def new
    @question = Question.new
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      render json: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @question = Question.find(params[:id])
      @question.destroy
      render json: { message: 'Question deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this question' }
    end
  end

  private

  def question_params
    params.require(:question).permit(:question_text, :time, :question_type, :correct_answer, :quiz_id)
  end
end
