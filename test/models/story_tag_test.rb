# frozen_string_literal: true

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
require 'test_helper'

class StoryTagTest < ActiveSupport::TestCase
  setup do
    @story = create(:story)
    @tag = create(:tag)
  end

  test 'should create' do
    story_tag = StoryTag.create(story: @story, tag: @tag)

    assert story_tag.valid?
  end

  test 'should not create without story and should return validation error' do
    story_tag = StoryTag.create(tag: @tag)

    assert_not story_tag.valid?
    assert_equal ['Story must exist'], story_tag.errors.full_messages
  end

  test 'should not create without tag and should return validation error' do
    story_tag = StoryTag.create(story: @story)

    assert_not story_tag.valid?
    assert_equal ['Tag must exist'], story_tag.errors.full_messages
  end

  test 'destroy should destroy orphan tag' do
    story_tag = create(:story_tag, story: @story, tag: @tag)

    assert_difference 'Tag.count', -1 do
      story_tag.destroy
    end
  end

  test 'destroy should not destroy non-orphan tag' do
    create(:story_tag, tag: @tag)
    story_tag = create(:story_tag, story: @story, tag: @tag)

    assert_difference 'Tag.count', 0 do
      story_tag.destroy
    end
  end
end
