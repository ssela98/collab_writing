# frozen_string_literal: true

module VoteHelper
  def upvote_label(votable, user)
    vote_message = if user.voted_up_on? votable, vote_scope: 'like'
                     'UN-vote'
                   else
                     'UP-vote'
                   end
    tag.span do
      "#{votable.cached_scoped_like_votes_up} #{vote_message}"
    end
  end

  def downvote_label(votable, user)
    vote_message = if user.voted_down_on? votable, vote_scope: 'like'
                     'UN-vote'
                   else
                     'DOWN-vote'
                   end
    tag.span do
      "#{votable.cached_scoped_like_votes_down} #{vote_message}"
    end
  end
end
