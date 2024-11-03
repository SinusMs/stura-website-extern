class UsersController < ApplicationController
  def new
    if not helpers.current_user.is_admin
      redirect_to root_path
    end
    @user = User.new
  end

  def create
    if not helpers.current_user.is_admin
      redirect_to root_path
      return
    end
    if User.exists? username: user_params[:username]
      redirect_to request.referrer, notice: "Username " + user_params[:username] + " already exists"
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

  def show
    if not helpers.current_user.is_admin
      redirect_to root_path
    end
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
