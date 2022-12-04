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
  # test "the truth" do
  #   assert true
  # end
end
