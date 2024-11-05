class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    if !helpers.is_admin?
      redirect_to backend_root_path
      return
    end
    @users = User.all
  end

  def show
    if access_to_user_denied?
      redirect_to backend_root_path
    end
  end

  def new
    if !helpers.is_admin?
      redirect_to backend_root_path
    end
    @user = User.new
  end

  def edit
    if access_to_user_denied?
      redirect_to backend_root_path
    end
  end

  def create
    if !helpers.is_admin?
      redirect_to backend_root_path
      return
    end

    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if access_to_user_denied?
      redirect_to backend_root_path
      return
    end

    respond_to do |format|
      password_success = user_params[:password].empty? || @user.update(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      if password_success && @user.update(user_params.except :password, :password_confirmation)
        format.html { redirect_to @user, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if access_to_user_denied?
      redirect_to backend_root_path
      return
    end

    # logout if the currently logged in user is being deleted
    if session[:user_id] == @user.id
      session[:user_id] = nil
    end

    @user.destroy!

    respond_to do |format|
      format.html { render :destroy, status: :see_other, notice: "User " + @user.username + " was successfully destroyed." }
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

  def access_to_user_denied?
    !helpers.is_admin? && !(helpers.current_user&.id == params[:id])
  end
end
