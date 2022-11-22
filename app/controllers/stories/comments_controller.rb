# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    # Use callbacks to share @commentable between actions.
    def set_commentable
      @commentable = Story.find(params[:story_id])
    end
  end
end
