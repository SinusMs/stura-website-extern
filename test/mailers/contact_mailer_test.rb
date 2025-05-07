require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "contact" do
    mail = ContactMailer.with(contact_email_address_id: contact_email_addresses(:stu).id, text: user_text, email: user_email, email_confirmation: user_email).contact
    assert_equal "Contact request by " + user_email, mail.subject
    assert_equal [ contact_email_addresses(:stu).email_address ], mail.to
    assert_equal [ user_email ], mail.from
    puts mail.body.encoded
    assert_match Regexp.new(user_text), mail.body.encoded
  end

  def user_email
    "max@mustermann.de"
  end
  def user_text
    "Hallo! K=C3=B6nnt ihr mir bei meinem Baf=C3=B6g-Antrag helfen?"
  end
end
