class UsersController < ApplicationController
  layout "application"
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :verify_rights_to_access_user, only: %i[ show edit update destroy ]
  before_action :verify_is_admin, only: %i[ index new create ]

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
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # check if a non-admin user tries to make themselve an admin
    if params[:is_admin] == true && !helpers.current_user.is_admin
      return head :unauthorized
    end

    respond_to do |format|
      password_success = user_params[:password].empty? || @user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      if password_success && @user.update(user_params.except :password, :password_confirmation)
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :is_admin)
  end

  def verify_rights_to_access_user
    if !helpers.is_admin? && !(helpers.current_user&.id.to_i == params[:id].to_i)
      head :unauthorized
    end
  end

  def verify_is_admin
    if !helpers.is_admin?
      head :unauthorized
    end
  end
end
