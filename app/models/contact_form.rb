# NOTE: This is NOT an ActiveRecord Model with corresponding Database Relation
# It is just a Model used for form validation
class ContactForm
  include ActiveModel::Model

  attr_accessor :contact_email_address_id, :email, :email_confirmation, :text

  validates :contact_email_address_id, :email, :email_confirmation, :text, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, confirmation: true

  validate :contact_email_address_id_must_exist

  def contact_email_address_id_must_exist
    unless ContactEmailAddress.exists?(id: contact_email_address_id)
      errors.add(:contact_email_address_id, "nicht gefunden")
    end
  end

  def deliver
    return false unless valid?

    mailer = ContactMailer.with(contact_form: self)
    mailer.contact.deliver_now
  end
end
