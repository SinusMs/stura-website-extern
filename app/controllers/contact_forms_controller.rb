class ContactFormsController < ApplicationController
  def index
    @contact_names = ContactEmailAddress.select("contact_email_addresses.name")
  end
  def post
     ContactMailer.with(contact_email_address_id: params[:contact_email_address_id], text: params[:text], your_email: params[:your_email]).contact.deliver_now
     redirect_to request.referrer, notice: "Your Request has been Sent!"
  end
end
