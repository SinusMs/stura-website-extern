require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    @settings = settings(:settings)
  end

  test "should update Settings" do
    visit settings_url

    fill_in "Showarticlesfordays", with: @settings.showArticlesForDays
    click_on "Update Settings"

    assert_text "Settings was successfully updated"
    click_on "Back"
  end
end
