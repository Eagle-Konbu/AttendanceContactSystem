require "application_system_test_case"

class LineGroupForBotsTest < ApplicationSystemTestCase
  setup do
    @line_group_for_bot = line_group_for_bots(:one)
  end

  test "visiting the index" do
    visit line_group_for_bots_url
    assert_selector "h1", text: "Line Group For Bots"
  end

  test "creating a Line group for bot" do
    visit line_group_for_bots_url
    click_on "New Line Group For Bot"

    fill_in "Group", with: @line_group_for_bot.group_id
    click_on "Create Line group for bot"

    assert_text "Line group for bot was successfully created"
    click_on "Back"
  end

  test "updating a Line group for bot" do
    visit line_group_for_bots_url
    click_on "Edit", match: :first

    fill_in "Group", with: @line_group_for_bot.group_id
    click_on "Update Line group for bot"

    assert_text "Line group for bot was successfully updated"
    click_on "Back"
  end

  test "destroying a Line group for bot" do
    visit line_group_for_bots_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Line group for bot was successfully destroyed"
  end
end
