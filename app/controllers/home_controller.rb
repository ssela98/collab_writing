# frozen_string_literal: true

class HomeController < ApplicationController
  include FilterableAndOrderable

  def index
    filtered_and_ordered_stories(Story.where(visible: true))
  end
end
