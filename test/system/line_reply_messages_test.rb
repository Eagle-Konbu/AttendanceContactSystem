require "application_system_test_case"

class LineReplyMessagesTest < ApplicationSystemTestCase
  setup do
    @line_reply_message = line_reply_messages(:one)
  end

  test "visiting the index" do
    visit line_reply_messages_url
    assert_selector "h1", text: "Line Reply Messages"
  end

  test "creating a Line reply message" do
    visit line_reply_messages_url
    click_on "New Line Reply Message"

    fill_in "Detail", with: @line_reply_message.detail
    click_on "Create Line reply message"

    assert_text "Line reply message was successfully created"
    click_on "Back"
  end

  test "updating a Line reply message" do
    visit line_reply_messages_url
    click_on "Edit", match: :first

    fill_in "Detail", with: @line_reply_message.detail
    click_on "Update Line reply message"

    assert_text "Line reply message was successfully updated"
    click_on "Back"
  end

  test "destroying a Line reply message" do
    visit line_reply_messages_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Line reply message was successfully destroyed"
  end
end
