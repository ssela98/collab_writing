# frozen_string_literal: true

class StoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_story, only: %i[show edit update destroy]
  before_action :forbidden_unless_creator, only: %i[edit update destroy]

  # GET /stories or /stories.json
  def index
    @stories = Story.all
  end

  # GET /stories/1 or /stories/1.json
  def show; end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit; end

  # POST /stories or /stories.json
  def create
    @story = Story.new(story_params.merge(user: current_user))

    respond_to do |format|
      if @story.save
        format.html { redirect_to story_url(@story), notice: I18n.t('stories.notices.successfully_created') }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to story_url(@story), notice: I18n.t('stories.notices.successfully_updated') }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url, notice: I18n.t('stories.notices.successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Do not allow edit, update or destroy changes if the logged in user
  # is not the creator of the story
  def forbidden_unless_creator
    return if current_user == @story.user

    flash.now[:alert] = I18n.t('stories.alerts.not_the_creator')
    head :forbidden
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
