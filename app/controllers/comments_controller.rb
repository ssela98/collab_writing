# frozen_string_literal: true

class CommentsController < ApplicationController
  include ForbiddenUnlessCreator
  include FilterableAndOrderable
  include Vote

  before_action :authenticate_user!, except: :show
  before_action :set_story
  before_action :set_comment, only: %i[show edit update destroy]
  before_action :set_parent, only: %i[show new create]
  before_action -> { forbidden_unless_creator(@comment) }, except: %i[index show new create vote]

  def index
    comments = @story.comments.where(parent_id: nil)

    ordered_comments(comments)
  end

  def show; end

  def new
    @comment = Comment.new
  end

  def edit; end

  def create
    @comment = @story.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent&.id

    if @comment.save
      flash.now[:notice] = I18n.t('comments.notices.successfully_created')
      @new_comment = @story.comments.new
    else
      flash.now[:alert] = I18n.t('comments.errors.failed_to_create')

      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = I18n.t('comments.notices.successfully_updated')
    else
      flash.now[:alert] = I18n.t('comments.errors.failed_to_update')

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @story = @comment.story
    @comment.destroy

    if @comment.destroyed?
      flash.now[:notice] = I18n.t('comments.notices.successfully_destroyed')
    else
      flash.now[:alert] = I18n.t('comments.errors.failed_to_destroy')

      render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash')
    end
  end

  private

  def set_vote_vars
    @votable = Comment.find_by(id: params[:id])
    @vote_path = 'vote_comment_path'
    @vote_params = { story_id: @votable.story_id, id: @votable.id }
  end

  def set_story
    @story = Story.find_by(id: params[:story_id])
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def set_parent
    @parent = Comment.find_by(id: params[:parent_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
