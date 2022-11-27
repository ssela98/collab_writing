# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include ActionView::RecordIdentifier
    include RecordHelper

    before_action :authenticate_user!, except: %i[show]
    before_action :set_story
    before_action :set_comment
    before_action :forbidden_unless_creator, except: %i[show create]

    def show; end

    def edit; end

    def create
      @parent = Comment.find_by(id: params[:comment_id])
      @comment = @story.comments.new(comment_params)
      @comment.user = current_user
      @comment.parent_id = @parent&.id

      if @comment.save
        flash.now[:notice] = I18n.t('comments.notices.successfully_created')
        @new_comment = @story.comments.new

        @locals = { data: { comment_reply_target: :form }, class: "d-none" } if @parent
      else
        flash.now[:alert] = I18n.t('comments.errors.failed_to_create')
      end
    end

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
      @story = @comment.story
      @comment.destroy

      if @comment.destroyed?
        flash.now[:notice] = I18n.t('comments.notices.successfully_destroyed')
      else
        flash.now[:alert] = I18n.t('comments.errors.failed_to_destroy')
      end
    end

    private

    def forbidden_unless_creator
      return if current_user == @comment.user

      respond_to do |format|
        flash.now[:alert] = I18n.t('comments.alerts.not_the_creator')
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
      end
    end

    def set_story
      @story = Story.find(params[:story_id])
    end

    def set_comment
      @comment = Comment.find_by(id: params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
  end
end
