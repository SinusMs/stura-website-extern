require "test_helper"

class ContactFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_contact_form = { contact_email_address_id: contact_email_addresses(:public_relations).id, email: "email@address.com", email_confirmation: "email@address.com", text: "help needed!" }
  end

  test "should get index" do
    get contact_forms_url
    assert_response :success
  end

  test "should send email" do
    assert_emails 1 do
      post contact_forms_url, params: { contact_form: @valid_contact_form }
      assert_redirected_to contact_forms_url
    end
  end

  test "should handle invalid form" do
    assert_emails 0 do
      post contact_forms_url, params: { contact_form: { contact_email_address_id: @valid_contact_form[:contact_email_address_id], email: "lol", email_confirmation: "lel", text: nil } }
      assert_response :unprocessable_content
    end
    assert_emails 0 do
      post contact_forms_url, params: { contact_form: { contact_email_address_id: 345634, email: @valid_contact_form[:email], email_confirmation: @valid_contact_form[:email_confirmation], text: @valid_contact_form[:text] } }
      assert_response :unprocessable_content
    end
  end
end
