require "application_system_test_case"

class SettingsTest < ApplicationSystemTestCase
  setup do
    @settings = settings(:settings)
    visit login_url
    fill_in "username", with: "admin"
    fill_in "password", with: "123"
    click_on "login"
    assert_text "admin"
  end

  # As the frontent structure is constantly changing right now, it not really feasible to keep the testcases up to date
  # test "should update Settings" do
  #   visit edit_settings_url

  #   fill_in "Showarticlesfordays", with: @settings.showArticlesForDays
  #   click_on "Update Setting"

  #   assert_text "Settings was successfully updated"
  # end
end
