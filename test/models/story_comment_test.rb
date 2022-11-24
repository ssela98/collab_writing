# frozen_string_literal: true

# == Schema Information
#
# Table name: story_comments
#
#  id         :integer          not null, primary key
#  story_id   :integer          not null
#  comment_id :integer          not null
#  sequence   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class StoryCommentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
