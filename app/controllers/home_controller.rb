# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    time_filter = case params[:filter_by_time]
                  when 'today'
                    Date.today.at_beginning_of_day
                  when 'this_week'
                    Date.today.at_beginning_of_week
                  when 'this_month'
                    Date.today.at_beginning_of_month
                  when 'this_year'
                    Date.today.at_beginning_of_year
                  end
    filtered_stories = Story.where(visible: true).filter_by_time(time_filter)
    order_by_votes = { cached_weighted_like_score: :desc } if params[:order_by]&.[]('top')
    order_by_time = { created_at: params[:order_by]&.[]('new') ? :asc : :desc }
    filtered_and_ordered_stories = filtered_stories.order(order_by_votes).order(order_by_time).with_rich_text_content

    @pagy, @stories = pagy(filtered_and_ordered_stories, items: 50)
  end
end
