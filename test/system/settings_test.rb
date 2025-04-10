require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    @settings = settings(:settings)
    visit login_url
    fill_in "username", with: "admin"
    fill_in "password", with: "123"
    click_on "login"
    assert_text "Logged in: true"
  end

  test "should update Settings" do
    visit edit_settings_url

    fill_in "Showarticlesfordays", with: @settings.showArticlesForDays
    click_on "Update Setting"

    assert_text "Settings was successfully updated"
    click_on "Back"
  end
end
