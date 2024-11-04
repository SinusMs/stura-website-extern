class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    if not helpers.is_admin?
      redirect_to root_path
      return
    end
    @users = User.all
  end

  def show
    if not helpers.is_admin?
      redirect_to root_path
    end
  end

  def new
    if not helpers.is_admin?
      redirect_to root_path
    end
    @user = User.new
  end

  def edit
  end

  def create
    if !helpers.is_admin?
      redirect_to root_path
      return
    end
    if User.exists? username: user_params[:username]
      redirect_to request.referrer, notice: "Username " + user_params[:username] + " already exists!"
      return
    end
    @user = User.new(user_params)
    @user.is_admin = false
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if  !helpers.logged_in? ||
        !(helpers.is_admin? || helpers.current_user.id == params[:id])
      redirect_to root_path
      return
    end
    respond_to do |format|
      if  @user.update(password: update_user_params[:new_password], password_confirmation: update_user_params[:repeat_new_password]) &&
          @user.update(update_user_params.slice :username)
        format.html { redirect_to @user, notice: "User was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
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
    params.require(:user).permit(:username, :password, :new_password, :repeat_new_password)
  end
end
