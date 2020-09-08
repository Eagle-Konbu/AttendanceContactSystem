require 'test_helper'

class ExecutiveControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get executive_index_url
    assert_response :success
  end

end
