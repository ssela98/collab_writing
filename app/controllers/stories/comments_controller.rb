# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include ActionView::RecordIdentifier
    include RecordHelper

    before_action :authenticate_user!
    before_action :set_story
    before_action :set_comment
    before_action :forbidden_unless_creator, except: %i[create]

    def show; end

    def edit; end

    def create
      @comment = @story.comments.new(comment_params)
      @parent = Comment.find_by(id: params[:comment_id])
      @comment.user = current_user
      @comment.parent_id = @parent&.id

      respond_to do |format|
        if @comment.save
          flash.now[:notice] = I18n.t('comments.notices.successfully_created')
          comment = @story.comments.new

          format.turbo_stream {
            if @parent # if replied to another comment
              render turbo_stream: [
                turbo_stream.prepend("#{dom_id(@parent)}_comments", partial: 'stories/comments/comment_with_replies', locals: { comment: @comment }),
                turbo_stream.replace(dom_id_for_records(@parent, comment), partial: "stories/comments/form", locals: { comment: comment, target: @parent, data: { comment_reply_target: :form }, class: "d-none" }),
                turbo_stream.prepend('flash', partial: 'shared/flash')
              ]
            else # if commented on the story directly
              render turbo_stream: [
                turbo_stream.prepend("#{dom_id(@story)}_comments", partial: 'stories/comments/comment_with_replies', locals: { comment: @comment }),
                turbo_stream.replace(dom_id_for_records(@story, comment), partial: "stories/comments/form", locals: { comment: comment, target: @story }),
                turbo_stream.prepend('flash', partial: 'shared/flash')
              ]
            end
          }
        else
          flash.now[:alert] = I18n.t('comments.errors.failed_to_create')
          format.turbo_stream {
            render turbo_stream: [
              turbo_stream.replace(dom_id_for_records(@parent || @story, @comment), partial: "stories/comments/form", locals: { comment: @comment, target: @parent || @story }),
              turbo_stream.prepend('flash', partial: 'shared/flash')
            ]
          }
        end
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

    # Do not allow edit, update or destroy changes if the logged in user
    # is not the creator of the story
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
