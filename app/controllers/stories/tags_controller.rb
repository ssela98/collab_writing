# frozen_string_literal: true

module Stories
  class TagsController < ApplicationController
    include ForbiddenUnlessCreator

    before_action :authenticate_user!
    before_action :set_tag
    before_action :set_story
    before_action -> { forbidden_unless_creator(@story) }

    def create
      if @tag.valid?
        #StoryTag.create(tag: @tag, story: @story)
        @new_tag = Tag.new

        flash.now[:notice] = I18n.t('tags.notices.successfully_created')
      else
        flash.now[:alert] = I18n.t('tags.errors.failed_to_create')
      end
    end

    def update; end

    def destroy
      @tag.destroy

      if @tag.destroyed?
        flash.now[:notice] = I18n.t('tags.notices.successfully_destroyed')
      else
        flash.now[:alert] = I18n.t('tags.errors.failed_to_destroy')
      end
    end

    private

    def set_tag
      @tag = Tag.find_by(id: params[:id]) || Tag.new(tag_create_params)
    end

    def set_story
      @story = Story.find_by(id: params[:story_id])
    end

    def tag_create_params
      params.require(:tag).permit(:name)
    end
  end
end
