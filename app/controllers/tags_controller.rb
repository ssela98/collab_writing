# frozen_string_literal: true

class TagsController < ApplicationController
  include ForbiddenUnlessCreator

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_story
  before_action -> { forbidden_unless_creator(@story) }, except: %i[index show new]
  before_action :set_tag_name, only: %i[show destroy]

  def index; end

  def show; end

  def new
    @tag = Tag.find_by(name: params[:name]) || Tag.new
  end

  def create
    @tag = Tag.find_or_initialize_by(params.require(:tag).permit(:name))
    if @tag.valid?
      @new_tag = Tag.new

      flash.now[:notice] = I18n.t('tags.notices.successfully_created')
    else
      # TODO: render new with "old" tag and errors
      flash.now[:alert] = I18n.t('tags.errors.failed_to_create')
    end
  end

  def destroy
    flash.now[:notice] = I18n.t('tags.notices.successfully_destroyed')
  end

  private

  def set_story
    @story = Story.find_by(id: params[:story_id]) || Story.new
  end

  def set_tag_name
    @tag_name = Tag.find_by(id: params[:name])&.name || params[:name]
  end
end
