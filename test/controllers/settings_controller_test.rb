require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @settings = settings(:settings)
  end

  test "should get edit only when logged in" do
    get edit_settings_url
    assert_response :unauthorized, "Non-logged-in user should not access settings edit page"
    login_user
    get edit_settings_url
    assert_response :success, "Logged-in user should access settings edit page"
    login_admin
    get edit_settings_url
    assert_response :success, "Logged-in admin should access settings edit page"
  end

  test "should update settings only when logged in" do
    patch settings_url, params: { setting: { showArticlesForDays: @settings.showArticlesForDays } }
    assert_response :unauthorized, "Non-logged-in user should not be able to update settings"

    login_user
    old_setting = @settings.showArticlesForDays
    patch settings_url, params: { setting: { showArticlesForDays: @settings.showArticlesForDays + 1 } }
    assert_redirected_to edit_settings_url, "Logged-in user should be redirected to settings edit page after update"
    @settings.reload
    assert_equal old_setting + 1, @settings.showArticlesForDays, "Settings should be updated by user"

    login_admin
    old_setting = @settings.showArticlesForDays
    patch settings_url, params: { setting: { showArticlesForDays: @settings.showArticlesForDays + 1 } }
    assert_redirected_to edit_settings_url, "Logged-in admin should be redirected to settings edit page after update"
    @settings.reload
    assert_equal old_setting + 1, @settings.showArticlesForDays, "Settings should be updated by admin"
  end

  test "should not update settings with invalid params" do
    login_admin
    assert_response :found, "Should log in as admin"
    patch settings_url, params: { setting: { showArticlesForDays: nil } }
    assert_response :unprocessable_content, "Should respond with unprocessable_entity for invalid update"
  end
end
