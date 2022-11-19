# frozen_string_literal: true

json.array! @stories, partial: 'stories/story', as: :story
