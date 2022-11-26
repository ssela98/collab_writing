# frozen_string_literal: true

class PinsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_pin, except: %i[create]
  before_action :set_story, only: %i[create]
  before_action :set_comment, only: %i[create]

  # POST /pins or /pins.json
  def create
    @pin = Pin.new(pin_create_params)

    if @pin.save
      flash.now[:notice] = I18n.t('pins.notices.successfully_created')
    else
      flash.now[:alert] = I18n.t('pins.errors.failed_to_create')
    end
  end

  # PATCH/PUT pins/1
  def update; end

  # DELETE /pins/1 or /pins/1.json
  def destroy
    @story = @pin.story
    @comment = @pin.comment
    @pin.destroy

    if @pin.destroyed?
      flash.now[:notice] = I18n.t('pins.notices.successfully_destroyed')
    else
      flash.now[:alert] = I18n.t('pins.errors.failed_to_destroy')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pin
    @pin = Pin.find(params[:id])
  end

  def set_story
    @story = Story.find(params[:pin][:story_id])
  end

  def set_comment
    @comment = Comment.find(params[:pin][:comment_id])
  end

  # Only allow a list of trusted parameters through.
  def pin_create_params
    params.require(:pin).permit(:story_id, :comment_id)
  end
end
