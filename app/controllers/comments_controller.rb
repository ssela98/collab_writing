# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash.now[:notice] = I18n.t('comments.notices.successfully_updated')

        format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
        format.html { redirect_to @comment }
      else
        flash.now[:alert] = I18n.t('comments.errors.failed_to_update')

        format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      flash.now[:notice] = I18n.t('comments.notices.successfully_destroyed')
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
      format.html { redirect_to @comment.commentable }
    end
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
