# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    session[:stories_filter_by] ||= 'all_time' # default filter
    session[:stories_order_by] ||= 'top' # default order

    session[:stories_filter_by] = params[:filter_by_date] if params[:filter_by_date]
    session[:stories_order_by] = params[:order_by] if params[:order_by]

    filtered_stories = Story.where(visible: true).filter_by_date_keyword(session[:stories_filter_by])
    filtered_and_ordered_stories = filtered_stories.order_by_keyword(session[:stories_order_by]).with_rich_text_content

    @pagy, @stories = pagy(filtered_and_ordered_stories, items: 50)
  end
end
