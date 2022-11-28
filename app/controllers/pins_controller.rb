# frozen_string_literal: true

class PinsController < ApplicationController
  include ForbiddenUnlessCreator

  before_action :authenticate_user!
  before_action :set_pin
  before_action :set_story
  before_action :set_comment
  before_action -> { forbidden_unless_creator(@story) }

  # POST /pins or /pins.json
  def create
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
    @pin = Pin.find_by(id: params[:id]) || Pin.new(pin_create_params)
  end

  def set_story
    @story = Story.find_by(id: params.dig('pin', 'story_id')) || @pin&.story
  end

  def set_comment
    @comment = Comment.find_by(id: params.dig('pin', 'comment_id')) || @pin&.comment
  end

  # Only allow a list of trusted parameters through.
  def pin_create_params
    params.require(:pin).permit(:story_id, :comment_id)
  end
end
