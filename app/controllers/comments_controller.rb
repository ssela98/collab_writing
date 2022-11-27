# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment
  before_action :forbidden_unless_creator

  def edit; end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = I18n.t('comments.notices.successfully_updated')
    else
      flash.now[:alert] = I18n.t('comments.errors.failed_to_update')
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @commentable = @comment.commentable
    @comment.destroy

    if @comment.destroyed?
      flash.now[:notice] = I18n.t('comments.notices.successfully_destroyed')
    else
      flash.now[:alert] = I18n.t('comments.errors.failed_to_destroy')
    end
  end

  private

  # Do not allow edit, update or destroy changes if the logged in user
  # is not the creator of the story
  def forbidden_unless_creator
    return if current_user == @comment.user

    respond_to do |format|
      flash.now[:alert] = I18n.t('comments.alerts.not_the_creator')
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
