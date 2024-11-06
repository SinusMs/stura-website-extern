class SessionsController < ApplicationController
  layout "backend"
  def login
    if helpers.logged_in?
      redirect_to backend_root_path
    end
  end

  def show
    if helpers.logged_in?
      @user = helpers.current_user
    end
  end

  def create
    @user = User.find_by(username: params[:username])

    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to backend_root_path
    else
      message = "Error trying to log in!"
      redirect_to login_path, notice: message
    end
  end

  def logout
    session[:user_id] = nil
    message = "Successfully logged out!"
    redirect_to login_path, notice: message
  end
end
