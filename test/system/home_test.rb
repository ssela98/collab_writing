# frozen_string_literal: true

require 'application_system_test_case'

class HomeTest < ApplicationSystemTestCase
  test 'should get all visible stories' do
    visible_story = create(:story) # should be displayed
    visible_story_2 = create(:story) # should be displayed
    visible_story_3 = create(:story) # should be displayed
    hidden_story = create(:story, visible: false)
    hidden_story_2 = create(:story, visible: false)

    visit root_url

    assert_equal 3, all('.story').size
    assert has_css?("##{dom_id visible_story}")
    assert has_css?("##{dom_id visible_story_2}")
    assert has_css?("##{dom_id visible_story_3}")
    assert has_no_css?("##{dom_id hidden_story}")
    assert has_no_css?("##{dom_id hidden_story_2}")
  end
end
