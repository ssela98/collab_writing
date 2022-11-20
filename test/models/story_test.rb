# frozen_string_literal: true

# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string           not null
#  visible    :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'should create' do
    story = Story.create(user_id: @user.id, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
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
    story = Story.create(user_id: @user.id, content: Faker::TvShows::BrooklynNineNine.quote)

    assert_not story.valid?
    assert_equal ["Title can't be blank"], story.errors.full_messages
  end

  test 'should create with large content' do
    story = Story.create(user_id: @user.id, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote, content: 'a' * 32768)

    assert story.valid?
    assert_equal 32768, story.content.to_plain_text.length
  end

  test 'should create with title with non-latin alphabet letters and special chars' do
    title = Faker::String.random
    story = Story.create(user_id: @user.id, title:, content: Faker::TvShows::BrooklynNineNine.quote)

    assert story.valid?
    assert_equal title, story.title
  end

  # TODO: fix text...
  # test 'should create with content with non-latin alphabet letters and special chars' do
  #   content = Faker::String.random
  #   story = Story.create(user_id: @user.id, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote, content:)

  #   assert story.valid?
  #   assert_equal content, story.content.to_plain_text
  # end

  test 'user relationship works' do
    story = Story.create(user_id: @user.id, title: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
                         content: Faker::TvShows::BrooklynNineNine.quote)

    assert_equal @user, story.user
  end
end
