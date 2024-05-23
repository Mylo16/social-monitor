class Api::V1::OptionsController < ApplicationController
  before_action :require_login
  # GET /options
  def index
    @question = Question.find(params[:question_id])
    @options = @question.options
    render json: @options
  end

  # GET /option/:id
  def show
    @question = Question.find(params[:question_id])
    @option = @question.options.find(params[:id])
    render json: @option
  end

  def create
    @option = Option.new(option_params)
    if @option.save
      render json: @option, status: :created
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  def new
    @option = Option.new
  end

  def update
    @option = Option.find(params[:id])
    if @option.update(option_params)
      render json: @option
    else
      render json: @option.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @question = Question.find(params[:question_id])
      @option = @question.options.find(params[:id])
      @option.destroy
      render json: { message: 'Option deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this option' }
    end
  end

  private

  def option_params
    params.require(:option).permit(:question_id, :option_text)
  end
end
