class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact
    @form = params[:contact_form]
    mail(
      to: ContactEmailAddress.find(@form.contact_email_address_id).email_address,
      from: @form.email,
      subject: "Contact request by #{@form.email}",
      content_type: "text/html; charset=UTF-8"
    )
  end
end
