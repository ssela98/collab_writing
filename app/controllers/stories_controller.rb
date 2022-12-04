# frozen_string_literal: true

class StoriesController < ApplicationController
  include ForbiddenUnlessCreator
  include Vote
  include FilterableAndOrderable

  before_action :authenticate_user!, except: :show
  before_action :set_story, except: %i[new create]
  before_action -> { forbidden_unless_creator(@story) }, only: %i[edit update destroy]
  before_action :batch_update_tags, only: %i[create update]

  def show
    comments = @story.comments.where(parent_id: nil)

    ordered_comments(comments)
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
    @vote_path = 'vote_story_path'
    @vote_params = { id: @votable.id }
  end

  def set_story
    @story = Story.find_by(id: params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :content, :visible)
  end

  def batch_update_tags
    tag_names = params.permit(tags: { tag: :name }).to_h['tags']&.map { |tag_h| tag_h[:tag][:name] } || []
    story_tags = @story.story_tags.joins(:tag)

    ActiveRecord::Base.transaction do
      story_tags.where.not(tags: { name: tag_names }).destroy_all

      (tag_names - story_tags.pluck('tags.name')).each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        @story.story_tags.create(tag_id: tag.id)
      end
    end
  end
end
