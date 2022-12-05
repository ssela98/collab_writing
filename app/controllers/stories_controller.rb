# frozen_string_literal: true

class StoriesController < ApplicationController
  include ForbiddenUnlessCreator
  include FilterableAndOrderable
  include Vote

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_story, except: %i[index new create]
  before_action -> { forbidden_unless_creator(@story) }, only: %i[edit update destroy]
  before_action :set_story_tags, except: %i[index new create destroy]
  before_action :set_tag_names, except: %i[index destroy]

  def index
    stories = if params[:username]
                user = User.find_by(username: params[:username])
                return unless user

                @username = params[:username]
                user.stories.where(current_user == user ? {} : { visible: true })
              else
                Story.where(visible: true)
              end

    filtered_and_ordered_stories(stories)
  end

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
      create_or_destroy_tags
      redirect_to @story, notice: I18n.t('stories.notices.successfully_created')
    else
      render :new, status: :unprocessable_entity, alert: I18n.t('stories.errors.failed_to_create')
    end
  end

  def update
    if @story.update(story_params)
      create_or_destroy_tags
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

  def set_story_tags
    @story_tags = @story.story_tags.joins(:tag)
  end

  def set_tag_names
    @tag_names = params.permit(story_tag_names: [])['story_tag_names'] || @story_tags&.pluck(:name) || []
  end

  def create_or_destroy_tags
    ActiveRecord::Base.transaction do
      @story_tags.where.not(tags: { name: @tag_names }).destroy_all if @story_tags

      (@tag_names - (@story_tags&.pluck('tags.name') || [])).each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        StoryTag.create(story_id: @story.id, tag_id: tag.id)
      end
    end
  end
end
