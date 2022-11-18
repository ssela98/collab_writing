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
  def setup
    @user = create(:user)
  end

  test 'creating works' do
    story = Story.create(user_id: @user.id, title: Faker::Games::WorldOfWarcraft.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
  end

  test 'creating without a user fails with validation message' do
    story = Story.create(title: Faker::Games::WorldOfWarcraft.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ["User can't be blank"], story.errors.full_messages
  end

  test 'creating without a title fails with validation message' do
    story = Story.create(user_id: @user.id, content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ["Title can't be blank"], story.errors.full_messages
  end

  test 'creating with too long title fails with validation message' do
    story = Story.create(user_id: @user.id, title: 'a' * 49,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ['Title is too long (maximum is 48 characters)'], story.errors.full_messages
  end

  test 'creating with large content works' do
    story = Story.create(user_id: @user.id, title: Faker::Games::WorldOfWarcraft.quote, content: 'a' * 32768)

    assert story.valid?
    assert_equal 32768, story.content.length
  end

  test 'creating with title with non-latin alphabet letters and special chars works' do
    story = Story.create(user_id: @user.id, title: '@#はàلвуйا', content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
    assert_equal '@#はàلвуйا', story.title
  end

  test 'creating with content with non-latin alphabet letters and special chars works' do
    story = Story.create(user_id: @user.id, title: Faker::Games::WorldOfWarcraft.quote, content: '@#はàلвуйا')

    assert story.valid?
    assert_equal '@#はàلвуйا', story.content
  end
end
