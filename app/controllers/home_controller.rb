# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    filtered_and_ordered_stories = Story.where(visible: true).order(updated_at: :desc).with_rich_text_content
    @pagy, @stories = pagy(filtered_and_ordered_stories, items: 50)
  end
end
