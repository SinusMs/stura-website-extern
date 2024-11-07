class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact
    email_address = ContactEmailAddress.find(params[:contact_email_address_id]).email_address
    @user_text = params[:text]
    @user_email = params[:your_email]
    mail to: email_address, from: params[:your_email], subject: "Contact request by " + params[:your_email], content_type: "text/html; charset=UTF-8"
  end
end
