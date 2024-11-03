class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact
    email_address = ContactEmailAddress.find(params[:name]).email_address
    @user_text = params[:text]
    @user_email = params[:your_email]
    mail to: email_address, subject: "Contact request by " + params[:your_email]
  end
end
