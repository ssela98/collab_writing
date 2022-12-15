# frozen_string_literal: true

# == Schema Information
#
# Table name: pins
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  comment_id :integer          not null
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class PinTest < ActiveSupport::TestCase
  setup do
    @comment = create(:comment)
  end

  test 'should create' do
    pin = Pin.create(comment: @comment, story: @comment.story)

    assert pin.valid?
  end

  test 'should not create without story and should return validation error' do
    pin = Pin.create(comment: @comment)

    assert_not pin.valid?
    assert_equal ['Story must exist', 'Comment can\'t be from another story'], pin.errors.full_messages
  end

  test 'should not create with comment from another story and should return validation error' do
    pin = Pin.create(comment: @comment, story: create(:story))

    assert_not pin.valid?
    assert_equal ['Comment can\'t be from another story'], pin.errors.full_messages
  end

  test 'should not create for same comment and should return validation error' do
    pin = create(:pin, comment: @comment)
    same_pin = Pin.create(comment: @comment, story: @comment.story)

    assert_not same_pin.valid?
    assert_equal ['Comment has already been taken'], same_pin.errors.full_messages
  end

  test 'should set sequence after create' do
    comment = create(:comment, story: @comment.story)
    comment_2 = create(:comment, story: @comment.story)
    pin = create(:pin, comment:)
    pin_2 = create(:pin, comment: comment_2)

    assert_equal 1, pin.sequence
    assert_equal 2, pin_2.sequence
  end

  test 'story and comment relationships work' do
    pin = create(:pin, comment: @comment)

    assert_equal @comment.story, pin.story
    assert_equal @comment, pin.comment
  end
end
