class ContactFormsController < ApplicationController
  def index
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.deliver
      redirect_to request.referrer, notice: "Your Request has been sent!"
    else
      # redirect_to request.referrer, notice: "Sending Message failed!"
      render :index, status: :unprocessable_entity
    end
  end

  private
  def contact_form_params
    params.require(:contact_form).permit(:contact_email_address_id, :email, :email_confirmation, :text)
  end
end
