# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(24)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'should create' do
    tag = Tag.create(name: Faker::Types.rb_string)

    assert tag.valid?
  end

  test 'should not create without name and should return validation errors' do
    tag = Tag.create

    assert_not tag.valid?
    assert_equal ['Name can\'t be blank'], tag.errors.full_messages
  end

  test 'story_tags relationship works' do
    story = create(:story)
    story_tag = create(:story_tag, story:)
    tag = story_tag.tag

    assert_equal [story_tag], tag.story_tags
  end

  test 'stories relationship works' do
    story = create(:story)
    story_tag = create(:story_tag, story:)
    tag = story_tag.tag

    assert_equal [story], tag.stories
  end
end
