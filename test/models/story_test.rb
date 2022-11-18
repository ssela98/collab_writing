# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string(48)       not null
#  content    :text
#  public     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class StoryTest < ActiveSupport::TestCase
  test 'creating a story works' do
    creator = create(:user)
    story = Story.create(user_id: creator.id, title: Faker::Games::WorldOfWarcraft.quote,
      content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
  end
end
