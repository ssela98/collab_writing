# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    acts_as_votable cacheable_strategy: :update_columns

    scope :order_by_keyword, lambda { |keyword|
      case keyword
      when 'top'
        order(cached_weighted_like_score: :desc).order(created_at: :desc)
      when 'new'
        order(created_at: :desc).order(cached_weighted_like_score: :desc)
      end
    }
  end

  # upvote or remove vote
  def upvote!(user)
    if user.voted_up_on? self, vote_scope: 'like'
      unvote_by user, vote_scope: 'like'
    else
      upvote_by user, vote_scope: 'like'
    end
  end

  # downvote or remove vote
  def downvote!(user)
    if user.voted_down_on? self, vote_scope: 'like'
      unvote_by user, vote_scope: 'like'
    else
      downvote_by user, vote_scope: 'like'
    end
  end
end
