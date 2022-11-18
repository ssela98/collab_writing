# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @stories = Story.where(visible: true)
  end
end
