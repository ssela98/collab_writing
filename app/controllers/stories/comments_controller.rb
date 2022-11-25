# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    def show
      @comment = Comment.find(params[:id])
    end

    private

    def set_commentable
      @commentable = Story.find(params[:story_id])
    end
  end
end
