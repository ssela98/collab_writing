# frozen_string_literal: true

module FilterableAndOrderable
  extend ActiveSupport::Concern

  def filtered_and_ordered_stories(stories)
    session[:stories_filter_by] ||= 'all_time' # default filter
    session[:stories_order_by] ||= 'top' # default order

    session[:stories_filter_by] = params[:filter_by_date] if params[:filter_by_date]
    session[:stories_order_by] = params[:order_by] if params[:order_by]

    filtered_stories = stories.filter_by_date_keyword(session[:stories_filter_by])
    filtered_and_ordered_stories = filtered_stories.order_by_keyword(session[:stories_order_by]).with_rich_text_content

    @pagy, @stories = pagy(filtered_and_ordered_stories, items: 25)
  end

  def ordered_comments(comments)
    session[:comments_order_by] ||= 'top' # default order
    session[:comments_order_by] = params[:order_by] if params[:order_by]

    @offset = params[:offset] || 0
    @limit = 10
    @comments_count = comments.count
    @comments = comments.limit(@limit).offset(@offset).order_by_keyword(session[:comments_order_by]).with_rich_text_content
  end
end
