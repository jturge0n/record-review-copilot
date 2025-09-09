require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get documents_new_url
    assert_response :success
  end

  test "should get create" do
    get documents_create_url
    assert_response :success
  end

  test "should get show" do
    get documents_show_url
    assert_response :success
  end

  test "should get process" do
    get documents_process_url
    assert_response :success
  end

  test "should get export" do
    get documents_export_url
    assert_response :success
  end

  test "should get salesforce_export" do
    get documents_salesforce_export_url
    assert_response :success
  end
end
