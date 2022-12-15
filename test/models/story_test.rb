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
    story = create(:story, content: 'a' * 32768)

    assert story.valid?
    assert_equal 32768, story.content.to_plain_text.length
  end

  test 'should create with title with non-latin alphabet letters and special chars' do
    title = Faker::String.random
    story = create(:story, title:)

    assert story.valid?
    assert_equal title, story.title
  end

  test 'voting works' do
    story = create(:story)

    story.upvote! @user
    assert_equal 1, story.weighted_score

    story.upvote! @user
    story.upvote! @user
    assert_equal 1, story.weighted_score # nothing changed

    story.downvote! @user
    assert_equal(-1, story.weighted_score)

    story.downvote! @user
    story.downvote! @user
    assert_equal(-1, story.weighted_score) # nothing changed
  end

  test 'ordering works' do
    story = create(:story)
    top_story = create(:story)
    newest_story = create(:story)

    top_story.upvote! @user

    assert_equal newest_story, Story.order_by_keyword('new').first
    assert_equal top_story, Story.order_by_keyword('top').first
  end

  test 'filtering works' do
    last_year_story = travel_to 1.year.ago do
      create(:story)
    end
    last_month_story = travel_to 1.month.ago do
      create(:story)
    end
    last_week_story = travel_to 1.week.ago do
      create(:story)
    end
    today_story = create(:story)

    assert_equal [last_year_story, last_month_story, last_week_story, today_story], Story.filter_by_date_keyword('all_time')
    assert_equal [last_month_story, last_week_story, today_story], Story.filter_by_date_keyword('this_year')
    assert_equal [last_week_story, today_story], Story.filter_by_date_keyword('this_month')
    assert_equal [today_story], Story.filter_by_date_keyword('this_week')
    assert_equal [today_story], Story.filter_by_date_keyword('today')
  end

  test 'user relationship works' do
    story = create(:story, user: @user)

    assert_equal @user, story.user
  end

  test 'comments relationship works' do
    story = create(:story)
    comment = create(:comment, story:)
    comment_2 = create(:comment, story:)

    assert_equal [comment, comment_2], story.comments
  end

  test 'pins relationship works' do
    story = create(:story)
    comment = create(:comment, story:)
    comment_2 = create(:comment, story:)
    pin = create(:pin, comment:)
    pin_2 = create(:pin, comment: comment_2)

    assert_equal [pin, pin_2], story.pins
  end

  test 'tags and story_tags relationship works' do
    story = create(:story)
    story_tag = create(:story_tag, story:)
    story_tag_2 = create(:story_tag, story:)

    assert_equal [story_tag, story_tag_2], story.story_tags
    assert_equal [story_tag.tag, story_tag_2.tag], story.tags
  end
end
