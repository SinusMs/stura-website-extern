module ApplicationHelper
  def logged_in?
    !session[:user_id].blank? && User.exists?(session[:user_id])
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if !session[:user_id].blank?
  end

  def is_admin?
    !session[:user_id].blank? && current_user&.is_admin
  end
end
