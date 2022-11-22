# frozen_string_literal: true

module Comments
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    # Use callbacks to share @commentable between actions.
    def set_commentable
      @parent = Comment.find(params[:comment_id])
      @commentable = @parent.commentable # Story
    end
  end
end
