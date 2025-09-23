require "test_helper"

class ContactEmailAddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact_email_address = contact_email_addresses(:stu)
    @contact_email_address2 = contact_email_addresses(:public_relations)
  end

  test "should get index" do
    get contact_email_addresses_url
    assert_response :unauthorized, "Non-logged-in user should not access contact email addresses index"
    login_user
    get contact_email_addresses_url
    assert_response :success, "Logged-in user should access contact email addresses index"
    login_admin
    get contact_email_addresses_url
    assert_response :success, "Admin should access contact email addresses index"
  end

  test "should get new" do
    get new_contact_email_address_url
    assert_response :unauthorized, "Non-logged-in user should not access new contact email address form"
    login_user
    get new_contact_email_address_url
    assert_response :success, "Logged-in user should access new contact email address form"
    login_admin
    get new_contact_email_address_url
    assert_response :success, "Admin should access new contact email address form"
  end

  test "should create contact_email_address" do
    assert_difference("ContactEmailAddress.count", 0, "Non-logged-in user should not be able to create a contact email address") do
      post contact_email_addresses_url, params: { contact_email_address: { email_address: "new@email.com", name: "New Contact Email" } }
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("ContactEmailAddress.count", 1, "Logged-in user should be able to create a contact email address") do
      post contact_email_addresses_url, params: { contact_email_address: { email_address: "new@email.com", name: "New Contact Email" } }
      assert_redirected_to contact_email_address_url(ContactEmailAddress.last), "Should redirect to newly created contact email address for logged-in user"
    end
    login_admin
    assert_difference("ContactEmailAddress.count", 1, "Admin should be able to create a contact email address") do
      post contact_email_addresses_url, params: { contact_email_address: { email_address: "newer@email.com", name: "Newer Contact Email" } }
      assert_redirected_to contact_email_address_url(ContactEmailAddress.last), "Should redirect to newly created contact email address for admin"
    end
  end

  test "should show contact_email_address" do
    get contact_email_address_url(@contact_email_address)
    assert_response :unauthorized, "Non-logged-in user should not view contact email address"
    login_user
    get contact_email_address_url(@contact_email_address)
    assert_response :success, "Logged-in user should view contact email address"
    login_admin
    get contact_email_address_url(@contact_email_address)
    assert_response :success, "Admin should view contact email address"
  end

  test "should get edit" do
    get edit_contact_email_address_url(@contact_email_address)
    assert_response :unauthorized, "Non-logged-in user should not access edit form"
    login_user
    get edit_contact_email_address_url(@contact_email_address)
    assert_response :success, "Logged-in user should access edit form"
    login_admin
    get edit_contact_email_address_url(@contact_email_address)
    assert_response :success, "Admin should access edit form"
  end

  test "should update contact_email_address" do
    oldname = @contact_email_address.name
    patch contact_email_address_url(@contact_email_address), params: { contact_email_address: { email_address: @contact_email_address.email_address, name: "newname" } }
    @contact_email_address.reload
    assert_equal oldname, @contact_email_address.name, "Non-logged-in user should not be able to update contact email address"
    assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    login_user
    patch contact_email_address_url(@contact_email_address), params: { contact_email_address: { email_address: @contact_email_address.email_address, name: "newname" } }
    @contact_email_address.reload
    assert_equal "newname", @contact_email_address.name, "Logged-in user should be able to update contact email address"
    assert_redirected_to contact_email_address_url(@contact_email_address), "Should redirect to contact email address after update for logged-in user"
    login_admin
    patch contact_email_address_url(@contact_email_address), params: { contact_email_address: { email_address: @contact_email_address.email_address, name: "newername" } }
    @contact_email_address.reload
    assert_equal "newername", @contact_email_address.name, "Admin should be able to update contact email address"
    assert_redirected_to contact_email_address_url(@contact_email_address), "Should redirect to contact email address after update for admin"
  end

  test "should destroy contact_email_address" do
    assert_difference("ContactEmailAddress.count", 0, "Non-logged-in user should not be able to destroy contact email address") do
      delete contact_email_address_url(@contact_email_address)
      assert_response :unauthorized, "Should respond with unauthorized for non-logged-in user"
    end
    login_user
    assert_difference("ContactEmailAddress.count", -1, "Logged-in user should be able to destroy contact email address") do
      delete contact_email_address_url(@contact_email_address)
      assert_redirected_to contact_email_addresses_url, "Should redirect to contact email addresses index after destroy for logged-in user"
    end
    login_admin
    assert_difference("ContactEmailAddress.count", -1, "Admin should be able to destroy contact email address") do
      delete contact_email_address_url(@contact_email_address2)
      assert_redirected_to contact_email_addresses_url, "Should redirect to contact email addresses index after destroy for admin"
    end
  end

  test "should handle invalid requests" do
    login_user
    get contact_email_address_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for non-existent contact email address"
    get edit_contact_email_address_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for edit form of non-existent contact email address"
    post edit_contact_email_address_url(id: 456763)
    assert_response :not_found, "Should respond with not_found for post to edit form of non-existent contact email address"
    patch contact_email_address_url(@contact_email_address), params: { contact_email_address: { name: @contact_email_address2.name } }
    assert_response :unprocessable_content, "Should respond with unprocessable_entity for invalid update (duplicate name)"
    delete contact_email_address_url(id: 456763)
    assert_response :not_found, "Should respond with not_found when trying to delete a non-existent contact email address"
  end
end
