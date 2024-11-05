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
  end

  def create
    if !helpers.is_admin?
      redirect_to backend_root_path
      return
    end
    if User.exists? username: user_params[:username]
      redirect_to request.referrer, notice: "Username " + user_params[:username] + " already exists!"
      return
    end
    @user = User.new(user_params)
    @user.is_admin = false
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if access_to_user_denied?
      redirect_to backend_root_path
      return
    end

    respond_to do |format|
      if  @user.update(password: update_user_params[:password], password_confirmation: update_user_params[:repeat_password]) &&
          @user.update(update_user_params.slice :username)
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
    params.require(:user).permit(:username, :password)
  end

  def update_user_params
    params.require(:user).permit(:username, :password, :password, :repeat_password)
  end

  def access_to_user_denied?
    !helpers.is_admin? && !helpers.current_user.id == params[:id]
  end
end
