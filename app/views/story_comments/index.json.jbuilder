# frozen_string_literal: true

json.array! @story_comments, partial: 'story_comments/story_comment', as: :story_comment
