# frozen_string_literal: true

module Vote
  extend ActiveSupport::Concern
  include VoteHelper

  included do
    before_action :set_votable, only: :vote
  end

  def vote
    case params[:type]
    when 'upvote'
      @votable.upvote! current_user
    when 'downvote'
      @votable.downvote! current_user
    else
      return respond_to do |format|
        format.html { redirect_to request.url, alert: I18n.t('votes.errors.vote_type') }
        flash.now[:alert] = I18n.t('votes.errors.vote_type')
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
      end
    end

    flash.now[:notice] = params[:type]
    respond_to do |format|
      format.turbo_stream { render :update }
    end
  end
end
