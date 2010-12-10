class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :admin?, :current_user

  private

  def admin?
    current_user && current_user.admin?
  end

  def current_spam_question
    @current_spam_question ||= SpamQuestion.find(session[:spam_question_id]) if session[:spam_question_id]
  end
  helper_method :current_spam_question

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end

  def login_required
    unless current_user
      store_target_location
      redirect_to root_url, :alert => "You must first sign in before accessing this page."
    end
  end

  def admin_required
    unless admin?
      redirect_to root_url, :alert => "Not authorized to access this page."
    end
  end

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def store_target_location
    session[:return_to] = request.url
  end
end
