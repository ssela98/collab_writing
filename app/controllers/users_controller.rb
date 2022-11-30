# frozen_string_literal: true

class UsersController < ApplicationController
  include FilterableAndOrderable

  before_action :set_user

  def show; end

  def stories
    stories = @user.stories
    stories = stories.where(visibile: true) unless current_user == @user

    filtered_and_ordered_stories(stories)
  end

  def comments
    comments = @user.comments
    comments = comments.joins(:story).where(story: { visible: true }) unless current_user == @user

    ordered_comments(comments)
  end

  def favourites; end

  private

  def set_user
    @user = User.find_by(username: params[:username])
  end
end
