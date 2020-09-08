require 'test_helper'

class LineReplyMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_reply_message = line_reply_messages(:one)
  end

  test "should get index" do
    get line_reply_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_line_reply_message_url
    assert_response :success
  end

  test "should create line_reply_message" do
    assert_difference('LineReplyMessage.count') do
      post line_reply_messages_url, params: { line_reply_message: { detail: @line_reply_message.detail } }
    end

    assert_redirected_to line_reply_message_url(LineReplyMessage.last)
  end

  test "should show line_reply_message" do
    get line_reply_message_url(@line_reply_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_reply_message_url(@line_reply_message)
    assert_response :success
  end

  test "should update line_reply_message" do
    patch line_reply_message_url(@line_reply_message), params: { line_reply_message: { detail: @line_reply_message.detail } }
    assert_redirected_to line_reply_message_url(@line_reply_message)
  end

  test "should destroy line_reply_message" do
    assert_difference('LineReplyMessage.count', -1) do
      delete line_reply_message_url(@line_reply_message)
    end

    assert_redirected_to line_reply_messages_url
  end
end
