class Api::V1::MaterialsController < ApplicationController
  before_action :require_login
  # GET /questions
  def index
    @course = Course.find(params[:course_id])
    @materials = @course.materials
    render json: @materials
  end

  # GET /questions/:id
  def show
    @material = Material.find(params[:id])
    render json: @material
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      render json: @material, status: :created
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  def new
    @material = Material.new
  end

  def update
    @material = Material.find(params[:id])
    if @material.update(material_params)
      render json: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if session_user.user_type == 'admin'
      @material = Material.find(params[:id])
      @material.destroy
      render json: { message: 'Material deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this material' }
    end
  end

  private

  def material_params
    params.require(:material).permit(:title, :description, :file_url, :course_id)
  end
end
