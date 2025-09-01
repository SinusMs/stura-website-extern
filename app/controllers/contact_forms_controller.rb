class ContactFormsController < ApplicationController
  invisible_captcha only: [ :create ], honeypot: :Anmerkung
  def index
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.deliver
      redirect_to (request.referrer.presence || contact_forms_path), notice: "Deine Anfrage ist bei uns eingegangen! Du wirst bald eine Antwort an \"#{@contact_form.email}\" erhalten."
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
  def contact_form_params
    params.require(:contact_form).permit(:contact_email_address_id, :email, :email_confirmation, :text)
  end
end
