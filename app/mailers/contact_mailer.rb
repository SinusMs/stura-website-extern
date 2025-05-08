class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact
    @form = params[:contact_form]
    @contact_email_address = ContactEmailAddress.find(@form.contact_email_address_id)
    mail(
      to: @contact_email_address.email_address,
      from: @form.email,
      subject: "#{@contact_email_address.name} request by #{@form.email}",
      content_type: "text/html; charset=UTF-8"
    )
  end
end
