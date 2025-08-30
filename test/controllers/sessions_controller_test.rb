require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "session flow" do
    get login_url
    assert_response :success, "expected to get login page"

    post login_url, params: { username: "admin", password: "123" }
    assert_response :found, "expected to log in successfully"

    get backend_root_url
    assert_response :success, "expected logged in user to be able to view backend landing page"

    get logout_path
    assert_redirected_to login_url, "expected to redirect to login page after successful logout"
  end

  test "should not get backend landing page when not logged in" do
    get backend_root_url
    assert_response :unauthorized
  end

  test "should not access login page as logged in user" do
    post login_url, params: { username: "admin", password: "123" }
    get login_url
    assert_redirected_to backend_root_url
  end

  test "login with incorrect credentials" do
    post login_url, params: { username: "hackerman", password: "123456789" }
    assert_redirected_to login_url
  end
end
