class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  layout "application"

  private
  def verify_is_logged_in
    if !helpers.logged_in?
      head :unauthorized
    end
  end

  def verify_is_admin
    if !helpers.is_admin?
      head :unauthorized
    end
  end
end
