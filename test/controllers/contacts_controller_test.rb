require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  test "should get send" do
    get contacts_send_url
    assert_response :success
  end

end
