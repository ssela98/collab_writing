# frozen_string_literal: true

# This controller is needed for Devise.
# Right now Devise is lagging behind Rails 7's Turbo and the flash
# messages are not working with :turbo_streams
#
# https://github.com/heartcombo/devise/issues/5446
# https://www.youtube.com/watch?v=yZDTBItc3ZM&t=316s
class TurboController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end
