# frozen_string_literal: true

module VoteHelper
  def upvote_icon(votable, user)
    return 'upvote_filled' if user&.voted_up_on? votable, vote_scope: 'like'

    'upvote'
  end

  def downvote_icon(votable, user)
    return 'downvote_filled' if user&.voted_down_on? votable, vote_scope: 'like'

    'downvote'
  end
end
