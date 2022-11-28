# frozen_string_literal: true

class StoriesController < ApplicationController
  include ForbiddenUnlessCreator
  include Vote

  before_action :authenticate_user!, except: :show
  before_action :set_story, except: %i[new create]
  before_action -> { forbidden_unless_creator(@story) }, only: %i[edit update destroy]

  def show
    @offset = params[:offset] || 0
    @limit = 10
    query = @story.comments.where(parent_id: nil)
    @comments_count = query.count
    @comments = query.limit(@limit).offset(@offset).order(created_at: :desc)
  end

  def new
    @story = Story.new
  end

  def edit; end

  def create
    @story = Story.new(story_params.merge(user: current_user))

    if @story.save
      redirect_to @story, notice: I18n.t('stories.notices.successfully_created')
    else
      render :new, status: :unprocessable_entity, alert: I18n.t('stories.errors.failed_to_create')
    end
  end

  def update
    if @story.update(story_params)
      flash.now[:notice] = I18n.t('stories.notices.successfully_updated')
    else
      flash.now[:alert] = I18n.t('stories.errors.failed_to_update')
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @story.destroy

    respond_to do |format|
      if @story.destroyed?
        format.html { redirect_to root_path, notice: I18n.t('stories.notices.successfully_destroyed') }
      else
        format.html { redirect_to @story, notice: I18n.t('stories.errors.failed_to_destroy') }
      end
    end
  end

  private

  def set_vote_vars
    @votable = Story.find_by(id: params[:id])
    @vote_path = "vote_story_path"
    @vote_params = { id: @votable.id }
  end

  def set_story
    @story = Story.find_by(id: params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :content, :visible)
  end
end
