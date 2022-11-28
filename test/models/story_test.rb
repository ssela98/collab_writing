# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id                             :integer          not null, primary key
#  user_id                        :integer          not null
#  title                          :string           not null
#  visible                        :boolean          default(TRUE)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  cached_scoped_like_votes_total :integer          default(0)
#  cached_scoped_like_votes_score :integer          default(0)
#  cached_scoped_like_votes_up    :integer          default(0)
#  cached_scoped_like_votes_down  :integer          default(0)
#  cached_weighted_like_score     :integer          default(0)
#  cached_weighted_like_total     :integer          default(0)
#  cached_weighted_like_average   :float            default(0.0)
#
require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'should create' do
    story = Story.create(user: @user, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
  end

  test 'should not create without user and should return validation error' do
    story = Story.create(title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ['User must exist'], story.errors.full_messages
  end

  test 'should not create without a title and should return validation error' do
    story = Story.create(user: @user, content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ["Title can't be blank"], story.errors.full_messages
  end

  test 'should create with large content' do
    story = Story.create(user: @user, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote, content: 'a' * 32768)

    assert story.valid?
    assert_equal 32768, story.content.to_plain_text.length
  end

  test 'should create with title with non-latin alphabet letters and special chars' do
    title = Faker::String.random
    story = Story.create(user: @user, title:, content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
    assert_equal title, story.title
  end

  test 'user relationship works' do
    story = Story.create(user: @user, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert_equal @user, story.user
  end
end
