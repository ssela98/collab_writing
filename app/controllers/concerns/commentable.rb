# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  included do
    before_action :authenticate_user!
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent&.id

    respond_to do |format|
      if @comment.save
        comment = Comment.new
        format.turbo_stream {
          if @parent
            # A successful reply to another comment, replace and hide this form
            render turbo_stream: turbo_stream.replace(dom_id_for_records(@parent, comment), partial: 'comments/form',
locals: { comment:, commentable: @parent, data: { comment_reply_target: :form }, class: 'd-none' })
          else
            render turbo_stream: turbo_stream.replace(dom_id_for_records(@commentable, comment), partial: 'comments/form',
locals: { comment:, commentable: @commentable })
          end
        }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@parent || @commentable, @comment), partial: 'comments/form',
locals: { comment: @comment, commentable: @parent || @commentable })
        }
      end
      format.html { redirect_to @commentable }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
