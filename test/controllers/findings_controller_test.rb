require "test_helper"

class FindingsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get findings_update_url
    assert_response :success
  end
end
