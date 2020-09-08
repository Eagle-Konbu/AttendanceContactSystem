require 'test_helper'

class LineGroupForBotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_group_for_bot = line_group_for_bots(:one)
  end

  test "should get index" do
    get line_group_for_bots_url
    assert_response :success
  end

  test "should get new" do
    get new_line_group_for_bot_url
    assert_response :success
  end

  test "should create line_group_for_bot" do
    assert_difference('LineGroupForBot.count') do
      post line_group_for_bots_url, params: { line_group_for_bot: { group_id: @line_group_for_bot.group_id } }
    end

    assert_redirected_to line_group_for_bot_url(LineGroupForBot.last)
  end

  test "should show line_group_for_bot" do
    get line_group_for_bot_url(@line_group_for_bot)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_group_for_bot_url(@line_group_for_bot)
    assert_response :success
  end

  test "should update line_group_for_bot" do
    patch line_group_for_bot_url(@line_group_for_bot), params: { line_group_for_bot: { group_id: @line_group_for_bot.group_id } }
    assert_redirected_to line_group_for_bot_url(@line_group_for_bot)
  end

  test "should destroy line_group_for_bot" do
    assert_difference('LineGroupForBot.count', -1) do
      delete line_group_for_bot_url(@line_group_for_bot)
    end

    assert_redirected_to line_group_for_bots_url
  end
end
