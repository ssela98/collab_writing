# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  included do
    before_action :authenticate_user!
    before_action :set_commentable
  end

  # POST /stories/:id/comments or /stories/:id/comments.json
  def create
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.save
        comment = Comment.new

        format.html { redirect_to @commentable }
        format.turbo_stream {
          flash.now[:notice] = I18n.t('comments.notices.successfully_created')
          render 'comments/create', comment:, commentable: @commentable
        }
      else
        format.html { redirect_to @commentable, status: :unprocessable_entity }
        format.turbo_stream {
          flash.now[:alert] = I18n.t('comments.errors.failed_to_create')
          render 'comments/create', comment: @comment, commentable: @commentable, status: :unprocessable_entity
        }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_commentable
    @commentable = Story.find(params[:story_id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
