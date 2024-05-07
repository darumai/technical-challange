require "test_helper"

class Api::V1::DocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get api_v1_documents_list_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_documents_create_url
    assert_response :success
  end
end
