require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @settings = settings(:settings)
    post login_url, params: { username: "admin", password: "123" }
  end

  test "should get edit" do
    get edit_settings_url
    assert_response :success
  end

  test "should update setting" do
    patch settings_url, params: { setting: { showArticlesForDays: @settings.showArticlesForDays } }
    assert_redirected_to edit_settings_url
  end
end
