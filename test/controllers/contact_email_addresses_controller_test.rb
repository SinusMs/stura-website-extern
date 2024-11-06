require "test_helper"

class ContactEmailAddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact_email_address = contact_email_addresses(:stu)
    post login_url, params: { username: "admin", password: "123" }
  end

  test "should get index" do
    get contact_email_addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_contact_email_address_url
    assert_response :success
  end

  test "should create contact_email_address" do
    assert_difference("ContactEmailAddress.count") do
      post contact_email_addresses_url, params: { contact_email_address: { email_address: @contact_email_address.email_address, name: @contact_email_address.name } }
    end

    assert_redirected_to contact_email_address_url(ContactEmailAddress.last)
  end

  test "should show contact_email_address" do
    get contact_email_address_url(@contact_email_address)
    assert_response :success
  end

  test "should get edit" do
    get edit_contact_email_address_url(@contact_email_address)
    assert_response :success
  end

  test "should update contact_email_address" do
    patch contact_email_address_url(@contact_email_address), params: { contact_email_address: { email_address: @contact_email_address.email_address, name: @contact_email_address.name } }
    assert_redirected_to contact_email_address_url(@contact_email_address)
  end

  test "should destroy contact_email_address" do
    assert_difference("ContactEmailAddress.count", -1) do
      delete contact_email_address_url(@contact_email_address)
    end

    assert_redirected_to contact_email_addresses_url
  end
end
