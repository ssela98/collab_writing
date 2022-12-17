# frozen_string_literal: true

require 'application_system_test_case'

class PinsTest < ApplicationSystemTestCase
  setup do
    @pin = create(:pin)
  end

  test "visiting the index" do
    visit pins_url
    assert_selector "h1", text: "Pins"
  end

  test "should create pin" do
    visit pins_url
    click_on "New pin"

    click_on "Create pin"

    assert_text "pin was successfully created"
    click_on "Back"
  end

  test "should update pin" do
    visit pin_url(@pin)
    click_on "Edit this pin", match: :first

    click_on "Update pin"

    assert_text "pin was successfully updated"
    click_on "Back"
  end

  test "should destroy pin" do
    visit pin_url(@pin)
    click_on "Destroy this pin", match: :first

    assert_text "pin was successfully destroyed"
  end
end
