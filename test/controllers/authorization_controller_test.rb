require "test_helper"

class AuthorizationControllerTest < ActionDispatch::IntegrationTest
  test "should get authorize" do
    get authorization_authorize_url
    assert_response :success
  end
end
