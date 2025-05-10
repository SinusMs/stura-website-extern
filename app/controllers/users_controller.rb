class UsersController < ApplicationController
  layout "application"
  before_action :set_user, only: %i[ show edit update destroy reset_password_request ]
  before_action :verify_rights_to_access_user, only: %i[ show edit update destroy reset_password_request ]
  before_action :verify_is_admin, only: %i[ index new create ]
  before_action :set_user_activation_link_and_user, only: %i[ activate submit_activation ]
  before_action :set_password_reset_link_and_user, only: %i[ reset_password submit_reset_password ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.password = @user.password_confirmation = SecureRandom.alphanumeric(32)
    activation_code = UserActivationCode.new(user: @user, code: SecureRandom.alphanumeric(32))
    respond_to do |format|
      if @user.save && activation_code.save
        UserMailer.with(user: @user, activation_code: activation_code).activate.deliver_now
        format.html { redirect_to @user, notice: "Account-Aktivierungslink an #{@user.email_address} gesendet!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # check if a non-admin user tries to adjust admin rights or directly change email address
    if !helpers.current_user.is_admin
      if user_params.key?(:is_admin) || user_params.key?(:email_address)
        return head :unauthorized
      end
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # logout if the currently logged in user is being deleted
    if session[:user_id] == @user.id
      session[:user_id] = nil
    end

    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User \"" + @user.username + "\" was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def activate
  end

  def submit_activation
    respond_to do |format|
      if @user.update(user_password_params)
        @user_activation_code.destroy
        format.html { redirect_to root_path, notice: "Account erfolgreich aktiviert! \nDu kannst dich nun einloggen!" }
      else
        format.html { render :activate, status: :unprocessable_entity }
      end
    end
  end

  def forgot_password
  end

  def submit_forgot_password
    @user = User.find_by(email_address: params[:email_address])
    if !@user
      redirect_to forgot_password_path, notice: "E-Mail Adresse nicht gefunden!"
      return
    end
    ResetPasswordCode.destroy_by(user: @user)
    reset_password_code = ResetPasswordCode.new(user: @user, code: SecureRandom.alphanumeric(32))
    if reset_password_code.save
      UserMailer.with(user: @user, reset_password_code: reset_password_code).reset_password_request.deliver_now
      redirect_to root_path, notice: "Ein E-Mail zum Zurücksetzen wurde an \"#{@user.email_address}\" gesendet."
    else
      redirect_to root_path, notice: "Fehler beim Erstellen des Zurücksetzungscodes."
    end
  end

  def reset_password_request
    ResetPasswordCode.destroy_by(user: @user)
    reset_password_code = ResetPasswordCode.new(user: @user, code: SecureRandom.alphanumeric(32))
    if reset_password_code.save
      UserMailer.with(user: @user, reset_password_code: reset_password_code).reset_password_request.deliver_now
      redirect_to root_path, notice: "Ein E-Mail zum Zurücksetzen wurde an \"#{@user.email_address}\" gesendet."
    else
      redirect_to root_path, notice: "Fehler beim Erstellen des Zurücksetzungscodes."
    end
  end

  def reset_password
  end

  def submit_reset_password
    respond_to do |format|
      if @user.update(user_password_params)
        @reset_password_code.destroy
        format.html { redirect_to root_path, notice: "Passwort und Nutzername erfolgreich zurückgesetzt! \nDu kannst dich nun einloggen!" }
      else
        format.html { render :reset_password, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_user_activation_link_and_user
    @user_activation_code = UserActivationCode.find_by(code: params[:code])
    if !@user_activation_code
      redirect_to root_path, notice: "Aktivierungslink ungültig!"
    else
      @user = @user_activation_code.user
    end
  end

  def set_password_reset_link_and_user
    @reset_password_code = ResetPasswordCode.find_by(code: params[:code])
    if !@reset_password_code
      redirect_to root_path, notice: "Zurücksetzunglink ungültig!"
    else
      @user = @reset_password_code.user
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :email_address, :is_admin)
  end

  def user_password_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def verify_rights_to_access_user
    if !helpers.is_admin? && !(helpers.current_user&.id.to_i == params[:id].to_i)
      head :unauthorized
    end
  end
end
