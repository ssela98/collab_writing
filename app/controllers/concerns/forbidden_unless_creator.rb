# frozen_string_literal: true

module ForbiddenUnlessCreator
  extend ActiveSupport::Concern

  def forbidden_unless_creator(resource)
    return if !resource.persisted? || current_user == resource.user

    respond_to do |format|
      alert_message = I18n.t("#{resource.class.name.underscore.pluralize}.alerts.not_the_creator")

      format.html { redirect_to resource, alert: alert_message }
      flash.now[:alert] = alert_message
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('flash', partial: 'shared/flash') }
    end
  end
end
