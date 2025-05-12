# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/contact
  def contact
    sample_form = ContactForm.new(
      email: "user@example.com",
      email_confirmation: "user@example.com",
      contact_email_address_id: ContactEmailAddress.first!.id,
      text: "This is a test message from the mailer preview.")

    ContactMailer.with(contact_form: sample_form).contact
  end

  def confirmation
    sample_form = ContactForm.new(
      email: "user@example.com",
      email_confirmation: "user@example.com",
      contact_email_address_id: ContactEmailAddress.first!.id,
      text: "This is a test message from the mailer preview.")

    ContactMailer.with(contact_form: sample_form).confirmation
  end
end
