# frozen_string_literal: true

class TagsController < ApplicationController
  include ForbiddenUnlessCreator

  before_action :authenticate_user!
  before_action :set_story
  before_action -> { forbidden_unless_creator(@story) }
  before_action :set_tag, only: %i[show new]

  def show; end

  def new; end

  def create
    @tag = Tag.find_or_initialize_by(params.require(:tag).permit(:name))
    if @tag.valid?
      @new_tag = Tag.new

      flash.now[:notice] = I18n.t('tags.notices.successfully_created')
    else
      flash.now[:alert] = I18n.t('tags.errors.failed_to_create')
    end
  end

  def destroy
    @tag_name = params[:name]
    flash.now[:notice] = I18n.t('tags.notices.successfully_destroyed')
  end

  private

  def set_story
    @story = Story.find_by(id: params[:story_id]) || Story.new
  end

  def set_tag
    @tag = Tag.find_by(id: params[:id]) || Tag.new
  end
end
