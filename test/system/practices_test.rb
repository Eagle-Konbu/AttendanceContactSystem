require "application_system_test_case"

class PracticesTest < ApplicationSystemTestCase
  setup do
    @practice = practices(:one)
  end

  test "visiting the index" do
    visit practices_url
    assert_selector "h1", text: "Practices"
  end

  test "creating a Practice" do
    visit practices_url
    click_on "New Practice"

    fill_in "Date", with: @practice.date
    fill_in "Name", with: @practice.name
    click_on "Create Practice"

    assert_text "Practice was successfully created"
    click_on "Back"
  end

  test "updating a Practice" do
    visit practices_url
    click_on "Edit", match: :first

    fill_in "Date", with: @practice.date
    fill_in "Name", with: @practice.name
    click_on "Update Practice"

    assert_text "Practice was successfully updated"
    click_on "Back"
  end

  test "destroying a Practice" do
    visit practices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Practice was successfully destroyed"
  end
end
