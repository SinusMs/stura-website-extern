class SessionsController < ApplicationController
  layout "application"
  before_action :verify_is_logged_in, only: [ :show ]
  invisible_captcha only: [ :create ], honeypot: :Wiederholung
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
      redirect_to backend_root_path, notice: "Angemeldet als: #{helpers.current_user.username}"
    else
      redirect_to login_path, notice: "Fehler beim Anmelden!"
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path, notice: "Erfolgreich abgemeldet!"
  end
end
