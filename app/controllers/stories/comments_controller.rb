# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include ActionView::RecordIdentifier
    include RecordHelper

    before_action :authenticate_user!
    before_action :set_comment, except: %i[create]
    before_action :set_commentable
    before_action :forbidden_unless_creator, only: %i[edit update destroy]

    # GET /stories/:story_id/comments/:id/edit
    def edit
      respond_to do |format|
        format.html { render 'comments/edit' }
      end
    end

    # POST /stories/:story_id/comments
    def create
      @comment = @commentable.comments.new(comment_create_params.merge(user: current_user))

      respond_to do |format|
        if @comment.save
          @comment = Comment.new

          format.html { redirect_to @commentable }
          format.turbo_stream {
            flash.now[:notice] = I18n.t('comments.notices.successfully_created')
            render 'comments/create'
          }
        else
          format.html { redirect_to @commentable, status: :unprocessable_entity }
          format.turbo_stream {
            flash.now[:alert] = I18n.t('comments.errors.failed_to_create')
            render 'comments/create', status: :unprocessable_entity
          }
        end
      end
    end

    # PATCH/PUT /stories/:story_id/comments/:id
    def update
      respond_to do |format|
        if @comment.update(comment_update_params)
          format.html { redirect_to @commentable }
          format.turbo_stream {
            flash.now[:notice] = I18n.t('comments.notices.successfully_updated')
            render turbo_stream: turbo_stream.prepend("flash", partial: "shared/flash")
          }
        else
          format.html { rendirect_to @commentable, status: :unprocessable_entity }
          format.turbo_stream {
            flash.now[:alert] = I18n.t('comments.errors.failed_to_update')
            render turbo_stream: turbo_stream.prepend("flash", partial: "shared/flash")
          }
        end
      end
    end

    # DELETE /stories/:story_id/comments/:id
    def destroy
      @comment.destroy

      respond_to do |format|
        format.html { redirect_to @commentable }
        format.turbo_stream {
          flash.now[:notice] = I18n.t('comments.notices.successfully_destroyed')
          render turbo_stream: turbo_stream.prepend("flash", partial: "shared/flash")
        }
      end
    end

    private

    # Do not allow edit, update or destroy changes if the logged in user
    # is not the creator of the story
    def forbidden_unless_creator
      return if current_user == @comment.user

      flash.now[:alert] = I18n.t('comments.alerts.not_the_creator')
      head :forbidden
    end

    # Use callbacks to share @comment between actions.
    def set_comment
      @comment = current_user.comments.find_by(id: params[:id])
    end

    # Use callbacks to share @commentable between actions.
    def set_commentable
      @commentable = Story.find(params[:story_id])
    end

    # Only allow a list of trusted parameters through for the create action.
    def comment_create_params
      params.require(:comment).permit(:content, :parent_id)
    end

    # Only allow a list of trusted parameters through for the update action.
    def comment_update_params
      params.require(:comment).permit(:content)
    end
  end
end
