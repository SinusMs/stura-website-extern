require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @settings = settings(:settings)
  end

  test "should get edit" do
    get edit_settings_url
    assert_response :success
  end

  test "should update setting" do
    patch settings_url, params: { settings: { showArticlesForDays: @settings.showArticlesForDays } }
    assert_redirected_to edit_settings_url
  end
end
