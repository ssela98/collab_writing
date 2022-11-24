# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  included do
    before_action :authenticate_user!, only: :create
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent&.id
    @comment.level = @parent&.level.to_i + 1

    respond_to do |format|
      if @comment.save
        comment = Comment.new

        format.turbo_stream {
          if @parent
            # A successful reply to another comment, replace and hide this form
            replace_form_and_render_flashes(@parent, comment, :notice,
                                            I18n.t('comments.notices.successfully_created'), { data: { comment_reply_target: :form }, class: 'd-none' })
          else
            replace_form_and_render_flashes(@commentable, comment, :notice, I18n.t('comments.notices.successfully_created'))
          end
        }
      else
        format.turbo_stream {
          replace_form_and_render_flashes(@parent || @commentable, @comment, :alert,
                                          I18n.t('comments.errors.failed_to_create'), { data: { comment_reply_target: :form } })
        }
      end
      format.html { redirect_to @commentable }
    end
  end

  private

  def replace_form_and_render_flashes(commentable, comment, flash_type, flash_message, locals_options = {})
    flash.now[flash_type] = flash_message

    render turbo_stream: [
      turbo_stream.replace(dom_id_for_records(commentable, comment), partial: 'comments/form',
        locals: { comment:, commentable: }.merge(locals_options)),
      turbo_stream.prepend('flash', partial: 'shared/flash')
    ]
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
