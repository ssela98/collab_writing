# frozen_string_literal: true

json.array! @pins, partial: 'pins/pin', as: :pin
