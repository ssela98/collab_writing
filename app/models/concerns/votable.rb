# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    acts_as_votable
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
