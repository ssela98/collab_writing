# == Schema Information
#
# Table name: story_tags
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  tag_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StoryTag < ApplicationRecord
  belongs_to :story
  belongs_to :tag

  after_commit -> { tag.destroy }, on: :destroy, if: -> { tag.story_tags.none? }
end
