class ContactEmailAddressesController < ApplicationController
  before_action :set_contact_email_address, only: %i[ show edit update destroy ]
  before_action :verify_rights_to_access_contact_email

  # GET /contact_email_addresses or /contact_email_addresses.json
  def index
    @contact_email_addresses = ContactEmailAddress.all
  end

  # GET /contact_email_addresses/1 or /contact_email_addresses/1.json
  def show
  end

  # GET /contact_email_addresses/new
  def new
    @contact_email_address = ContactEmailAddress.new
  end

  # GET /contact_email_addresses/1/edit
  def edit
  end

  # POST /contact_email_addresses or /contact_email_addresses.json
  def create
    @contact_email_address = ContactEmailAddress.new(contact_email_address_params)

    respond_to do |format|
      if @contact_email_address.save
        format.html { redirect_to @contact_email_address, notice: "Contact email address was successfully created." }
        format.json { render :show, status: :created, location: @contact_email_address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact_email_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_email_addresses/1 or /contact_email_addresses/1.json
  def update
    respond_to do |format|
      if @contact_email_address.update(contact_email_address_params)
        format.html { redirect_to @contact_email_address, notice: "Contact email address was successfully updated." }
        format.json { render :show, status: :ok, location: @contact_email_address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact_email_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_email_addresses/1 or /contact_email_addresses/1.json
  def destroy
    @contact_email_address.destroy!

    respond_to do |format|
      format.html { redirect_to contact_email_addresses_path, status: :see_other, notice: "Contact email address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_email_address
      @contact_email_address = ContactEmailAddress.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contact_email_address_params
      params.require(:contact_email_address).permit(:name, :email_address)
    end

    def verify_rights_to_access_contact_email
      if !helpers.logged_in?
        head :unauthorized
      end
    end
end
