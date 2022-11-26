# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_story, only: %i[show edit update destroy]
  before_action :forbidden_unless_creator, only: %i[edit update destroy]

  # GET /stories/1 or /stories/1.json
  def show
    @offset = params[:offset] || 0
    @limit = 10
    query = @story.comments.where(parent_id: nil)
    @comments_count = query.count
    @comments = query.limit(@limit).offset(@offset).order(created_at: :desc)
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit; end

  # POST /stories or /stories.json
  def create
    @story = Story.new(story_params.merge(user: current_user))

    if @story.save
      redirect_to @story, notice: I18n.t('stories.notices.successfully_created')
    else
      render :new, status: :unprocessable_entity, alert: I18n.t('stories.errors.failed_to_create')
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
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

  # DELETE /stories/1 or /stories/1.json
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

  # Do not allow edit, update or destroy changes if the logged in user
  # is not the creator of the story
  def forbidden_unless_creator
    return if current_user == @story.user

    respond_to do |format|
      format.html { redirect_to @story, alert: I18n.t('stories.alerts.not_the_creator') }
      flash.now[:alert] = I18n.t('stories.alerts.not_the_creator')
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_story
    @story = Story.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def story_params
    params.require(:story).permit(:title, :content, :visible)
  end
end
