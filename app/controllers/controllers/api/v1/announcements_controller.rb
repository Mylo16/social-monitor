class Api::V1::AnnouncementsController < ApplicationController
  before_action :require_login
  before_action :set_announcement, only: %i[ show update destroy ]

  # GET /announcements
  def index
    @announcements = Announcement.all

    render json: @announcements
  end

  # GET /announcements/1
  def show
    render json: @announcement
  end

  # POST /announcements
  def create
    @announcement = Announcement.new(announcement_params)

    if @announcement.save
      render json: @announcement, status: :created
    else
      render json: @announcement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /announcements/1
  def update
    if @announcement.update(announcement_params)
      render json: @announcement
    else
      render json: @announcement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /announcements/1
  def destroy
    if session_user.user_type == 'admin'
      @announcement.destroy
      render json: { message: 'Announcement deleted successfully' }
    else
      render json: { message: 'You don\'t have permission to delete this announcement' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def announcement_params
      params.require(:announcement).permit(:title, :content, :user_id)
    end
end
