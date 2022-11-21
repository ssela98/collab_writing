# frozen_string_literal: true

class NoAttachmentsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.body.attachments.any?

    record.errors.add(attribute, I18n.t('errors.messages.attachments_not_allowed'))
  end
end
