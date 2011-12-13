class ApplicationController < ActionController::Base
  protect_from_forgery
  enable_authorization do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

  # overrides ActionController::RequestForgeryProtection#handle_unverified_request
  def handle_unverified_request
    super
    cookies.delete(:token)
  end

  private

  def user_for_paper_trail
    current_user && current_user.id
  end

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end
  helper_method :current_user

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def store_target_location
    session[:return_to] = request.url
  end
end
