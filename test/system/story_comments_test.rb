require "application_system_test_case"

class StoryCommentsTest < ApplicationSystemTestCase
  setup do
    @story_comment = story_comments(:one)
  end

  test "visiting the index" do
    visit story_comments_url
    assert_selector "h1", text: "Story comments"
  end

  test "should create story comment" do
    visit story_comments_url
    click_on "New story comment"

    click_on "Create Story comment"

    assert_text "Story comment was successfully created"
    click_on "Back"
  end

  test "should update Story comment" do
    visit story_comment_url(@story_comment)
    click_on "Edit this story comment", match: :first

    click_on "Update Story comment"

    assert_text "Story comment was successfully updated"
    click_on "Back"
  end

  test "should destroy Story comment" do
    visit story_comment_url(@story_comment)
    click_on "Destroy this story comment", match: :first

    assert_text "Story comment was successfully destroyed"
  end
end
