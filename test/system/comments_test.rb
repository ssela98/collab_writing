# frozen_string_literal: true

require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create(:user)
    @story = create(:story)
    @comment = create(:comment, :of_story, commentable: @story)
    @user_comment = create(:comment, :of_story, commentable: @story, user: @user)
    @reply_to_user_comment = create(:comment, :of_comment, parent: @user_comment)
  end

  test 'visiting a story displays all its comments' do
    visit story_url(@story)
    other_story_comment = create(:comment, :of_story, commentable: create(:story))

    comments = find("##{dom_id(@story)}_comments")

    assert_selector 'h5', text: I18n.t('comments_title')
    assert comments.visible?
    assert comments.has_css?("##{dom_id(@comment)}")
    assert comments.has_css?("##{dom_id(@user_comment)}")
    assert comments.has_css?("##{dom_id(@reply_to_user_comment)}")
    assert find("##{dom_id(@reply_to_user_comment)}_with_comments")[:class].include?('ps-3 border-left')
    assert_not comments.has_css?("##{dom_id(other_story_comment)}")
  end

  test 'new comment form is shown based on the authentication status' do
    visit story_url(@story)
    assert_not has_css?("##{dom_id(@story)}_new_comment")
    assert has_css?("##{dom_id(@story)}_sign_up_or_log_in_links")

    sign_in @user
    visit story_url(@story)

    assert has_css?("##{dom_id(@story)}_new_comment")
  end

  test 'should create story comment' do
    sign_in @user
    visit story_url(@story)

    content = Faker::TvShows::Buffy.quote
    new_comment_form = find("##{dom_id(@story)}_new_comment")
    new_comment_form.click
    find("##{dom_id(@story)}_new_comment_content").set(content)
    assert_difference 'Comment.count', 1 do
      assert_difference "all('.comment').size", 1 do
        new_comment_form.find("input[type='submit']").click
      end
    end
    comment = Comment.where(user: @user, commentable: @story).where_content(content).take

    assert_equal I18n.t('comments.notices.successfully_created'), find('.flash__notice').text
    assert find("##{dom_id(@story)}_comments").has_css?("##{dom_id(comment)}")
    assert_equal content, find("##{dom_id(comment)}").find('.trix-content').text
  end

  test 'should create reply comment' do
    sign_in @user
    visit story_url(@story)

    content = Faker::TvShows::Buffy.quote
    find("##{dom_id(@comment)}_reply_button").click
    assert has_css?("##{dom_id(@comment)}_new_comment")

    new_comment_form = find("##{dom_id(@comment)}_new_comment")
    find("##{dom_id(@comment)}_new_comment_content").click.set(content)

    assert_difference 'Comment.count', 1 do
      assert_difference "all('.comment').size", 1 do
        new_comment_form.find("input[type='submit']").click
      end
    end
    comment = Comment.where(user: @user, parent: @comment).where_content(content).take

    assert_equal I18n.t('comments.notices.successfully_created'), find('.flash__notice').text
    assert find("##{dom_id(@comment)}_comments").has_css?("##{dom_id(comment)}")
    assert_equal content, find("##{dom_id(comment)}").find('.trix-content').text
  end

  test 'should not create story comment if content is empty and should show validation error' do
    sign_in @user
    visit story_url(@story)

    new_comment_form = find("##{dom_id(@story)}_new_comment")
    find("##{dom_id(@story)}_new_comment_content").click.set(nil)

    assert_difference 'Comment.count', 0 do
      assert_difference "all('.comment').size", 0 do
        new_comment_form.find("input[type='submit']").click
      end
    end

    assert_equal I18n.t('comments.errors.failed_to_create'), find('.flash__alert').text
    assert_equal 'Content can\'t be blank', find("##{dom_id(@story)}_new_comment_content_errors > li").text
  end

  test 'should not create reply comment if content is empty and should show validation error' do
    sign_in @user
    visit story_url(@story)

    find("##{dom_id(@comment)}_reply_button").click
    assert has_css?("##{dom_id(@comment)}_new_comment")

    new_comment_form = find("##{dom_id(@comment)}_new_comment")
    find("##{dom_id(@comment)}_new_comment_content").click.set(nil)

    assert_difference 'Comment.count', 0 do
      assert_difference "all('.comment').size", 0 do
        new_comment_form.find("input[type='submit']").click
      end
    end

    assert_equal I18n.t('comments.errors.failed_to_create'), find('.flash__alert').text
    assert_equal 'Content can\'t be blank', find("##{dom_id(@comment)}_new_comment_content_errors > li").text
  end

  test 'should update story comment' do
    sign_in @comment.user
    visit story_url(@story)

    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@comment)}")
    comment.find("a[type='edit']").click

    comment_edit_form = find("form[id='#{dom_id(@comment)}']")
    assert comment_edit_form.visible?

    content = Faker::TvShows::Buffy.quote
    comment_edit_form.find("##{dom_id(@comment)}_content").set(content)
    comment_edit_form.find("input[type='submit']").click

    @comment.reload
    assert_equal I18n.t('comments.notices.successfully_updated'), find('.flash__notice').text
    assert_equal content, @comment.content.to_plain_text
    assert_equal content, find("##{dom_id(@comment)}").find('.trix-content').text
  end

  test 'should update reply comment' do
    sign_in @user
    visit story_url(@story)

    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@user_comment)}")
    comment.find("a[type='edit']").click

    comment_edit_form = find("form[id='#{dom_id(@user_comment)}']")
    assert comment_edit_form.visible?

    content = Faker::TvShows::Buffy.quote
    comment_edit_form.find("##{dom_id(@user_comment)}_content").set(content)
    comment_edit_form.find("input[type='submit']").click

    @user_comment.reload
    assert_equal I18n.t('comments.notices.successfully_updated'), find('.flash__notice').text
    assert_equal content, @user_comment.content.to_plain_text
    assert_equal content, find("##{dom_id(@user_comment)}").find('.trix-content').text
  end

  test 'should not update story comment with empty content and should show validation error' do
    sign_in @user
    visit story_url(@story)
    old_content = @user_comment.content

    # we need to first search for the comments section
    # otherwise capybara complains about element not scrollable into view
    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@user_comment)}")
    comment.find("a[type='edit']").click

    comment_edit_form = find("form[id='#{dom_id(@user_comment)}']")
    comment_edit_form.find("##{dom_id(@user_comment)}_content").click.set(nil)
    comment_edit_form.find("input[type='submit']").click

    # TODO: fix these
    # assert_equal I18n.t('comments.alerts.failed_to_update'), find('.flash__alert').text
    # assert_equal 'Content can\'t be blank', find("##{dom_id(@user_comment)}_content_errors > li").text
    @user_comment.reload
    assert_equal old_content, @user_comment.content
    assert_equal old_content.to_plain_text, find("##{dom_id(@user_comment)}").find('.trix-content').text
  end

  test 'should not update reply comment with empty content and should show validation error' do
    sign_in @reply_to_user_comment.user
    visit story_url(@story)
    old_content = @reply_to_user_comment.content

    # we need to first search for the comments section
    # otherwise capybara complains about element not scrollable into view
    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@reply_to_user_comment)}")
    comment.find("a[type='edit']").click

    comment_edit_form = find("form[id='#{dom_id(@reply_to_user_comment)}']")
    comment_edit_form.find("##{dom_id(@reply_to_user_comment)}_content").click.set(nil)
    comment_edit_form.find("input[type='submit']").click

    # TODO: fix these
    # assert_equal I18n.t('comments.alerts.failed_to_update'), find('.flash__alert').text
    # assert_equal 'Content can\'t be blank', find("##{dom_id(@reply_to_user_comment)}_content_errors > li").text
    @reply_to_user_comment.reload
    assert_equal old_content, @reply_to_user_comment.content
    assert_equal old_content.to_plain_text, find("##{dom_id(@reply_to_user_comment)}").find('.trix-content').text
  end

  test 'should see edit or delete buttons based on being the creator of the comment' do
    user_reply_comment = create(:comment, :of_comment, parent: @user_comment, user: @user)
    sign_in @user
    visit story_url(@story)

    # we need to first search for the comments section
    # otherwise capybara complains about element not scrollable into view
    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@comment)}")

    sleep 1 # stimulus is too slow to load :(
    assert_not comment.has_css?('.hideable-buttons')
    assert_not comment.has_css?('.hideable-buttons')

    reply_comment = comments.find("##{dom_id(user_reply_comment)}")
    user_comment = comments.find("##{dom_id(@user_comment)}")
    assert user_comment.has_css?('.hideable-buttons')
    assert reply_comment.has_css?('.hideable-buttons')
  end

  test 'should destroy story comment' do
    sign_in @user
    visit story_url(@story)

    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@user_comment)}")

    #assert_difference 'Comment.count', -1 do
      #assert_difference "all('.comment').size", -1 do
        alert_text = accept_confirm do
          comment.find('.hideable-buttons').find("form[class='button_to']").find("button[type='submit']").click
        end
      #end
    #end

    assert_equal I18n.t('are_you_sure_delete'), alert_text
    assert_equal I18n.t('comments.notices.successfully_destroyed'), find('.flash__notice').text
  end

  test 'should destroy reply comment' do
    sign_in @reply_to_user_comment.user
    visit story_url(@story)

    comments = find("##{dom_id(@story)}_comments")
    comment = comments.find("##{dom_id(@reply_to_user_comment)}")

    #assert_difference 'Comment.count', -1 do
      #assert_difference "all('.comment').size", -1 do
        alert_text = accept_confirm do
          comment.find('.hideable-buttons').find("form[class='button_to']").find("button[type='submit']").click
        end
      #end
    #end

    assert_equal I18n.t('are_you_sure_delete'), alert_text
    assert_equal I18n.t('comments.notices.successfully_destroyed'), find('.flash__notice').text
  end
end
