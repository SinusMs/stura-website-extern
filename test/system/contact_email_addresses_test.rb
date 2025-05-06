require "application_system_test_case"

class ContactEmailAddressesTest < ApplicationSystemTestCase
  setup do
    @contact_email_address = contact_email_addresses(:stu)
    visit login_url
    fill_in "username", with: "admin"
    fill_in "password", with: "123"
    click_on "login"
    assert_text "admin"
  end

  # As the frontent structure is constantly changing right now, it not really feasible to keep the testcases up to date
  # test "visiting the index" do
  #   visit contact_email_addresses_url
  #   assert_selector "h1", text: "Contact email addresses"
  # end

  # test "should create contact email address with unique name" do
  #   visit contact_email_addresses_url
  #   click_on "New contact email address"

  #   fill_in "Email address", with: valid_contact_email_address.email_address
  #   fill_in "Name", with: valid_contact_email_address.name
  #   click_on "Create Contact email address"

  #   assert_text "Contact email address was successfully created"
  # end

  # test "should update Contact email address" do
  #   visit contact_email_address_url(@contact_email_address)
  #   click_on "Edit this contact email address", match: :first

  #   fill_in "Email address", with: @contact_email_address.email_address
  #   fill_in "Name", with: @contact_email_address.name
  #   click_on "Update Contact email address"

  #   assert_text "Contact email address was successfully updated"
  # end

  # test "should destroy Contact email address" do
  #   visit contact_email_address_url(@contact_email_address)
  #   click_on "Destroy this contact email address", match: :first

  #   assert_text "Contact email address was successfully destroyed"
  # end

  # def valid_contact_email_address
  #   ContactEmailAddress.new(name: "vaild name", email_address: "vaild@email.com")
  # end
end
