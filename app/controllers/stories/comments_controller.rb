# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable
    before_action :set_comment, only: :show

    def show; end

    private

    def set_commentable
      @commentable = Story.find(params[:story_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
end
