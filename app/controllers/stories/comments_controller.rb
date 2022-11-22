# frozen_string_literal: true

module Stories
  class CommentsController < ApplicationController
    include Commentable

    before_action :set_commentable

    private

    def set_commentable
      @commentable = Story.find(params[:story_id])
    end
  end
end
