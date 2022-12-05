# frozen_string_literal: true

class PinsController < ApplicationController
  include ForbiddenUnlessCreator

  before_action :authenticate_user!, except: :index
  before_action :set_pin, except: :index
  before_action :set_story, except: :index
  before_action :set_comment, except: :index
  before_action -> { forbidden_unless_creator(@story) }, except: :index

  def index
    @story = Story.find_by(id: params[:story_id])
  end

  def create
    if @pin.save
      flash.now[:notice] = I18n.t('pins.notices.successfully_created')
    else
      flash.now[:alert] = I18n.t('pins.errors.failed_to_create')
    end
  end

  def update; end

  def destroy
    @pin.destroy

    if @pin.destroyed?
      flash.now[:notice] = I18n.t('pins.notices.successfully_destroyed')
    else
      flash.now[:alert] = I18n.t('pins.errors.failed_to_destroy')
    end
  end

  private

  def set_pin
    @pin = Pin.find_by(id: params[:id]) || Pin.new(pin_create_params)
  end

  def set_story
    @story = Story.find_by(id: params.dig('pin', 'story_id')) || @pin&.story
  end

  def set_comment
    @comment = Comment.find_by(id: params.dig('pin', 'comment_id')) || @pin&.comment
  end

  def pin_create_params
    params.require(:pin).permit(:story_id, :comment_id)
  end
end
